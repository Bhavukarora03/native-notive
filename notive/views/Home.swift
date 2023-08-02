import SwiftUI

struct Home: View {
    
    @State var notes = [Note]()
    @State var showAddSheet = false
    @State var deleteItem: Note?
    @State var isEditMode : EditMode = .inactive
    @State var showAlert = false
    @State var updateNote = ""
		@State var updateNoteID = ""
    
    var alert: Alert{
        Alert(title: Text("Delete"),message: Text("Are you sure you wanna delete this memory"),  primaryButton: .destructive(Text("Delete"), action: deleteNote), secondaryButton: .cancel())
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, h:mm a"
        return formatter
    }
    var sortedNotes: [Note] {
        return notes.sorted(by: { $0.createdAt > $1.createdAt })
    }
		
		
    var body: some View {
        NavigationView {
            List(self.sortedNotes) { note in
                if(self.isEditMode == .inactive){
                    
                    HStack {
                        Text(note.note)
                            .onLongPressGesture {
                                self.showAlert.toggle()
                                deleteItem = note
                            }

                        Spacer()
                        if let date = iso8601DateFormatter.date(from: note.createdAt) {
                            Text(dateFormatter.string(from: date))
                                .font(.system(size: 8))
                                .foregroundColor(.gray).onTapGesture {
                                      
                                }
                                }
                        else {
                            Text("Invalid Date")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                        }
                    }
        
                    }
                else{
                    
                    HStack{
                        Image(systemName: "pencil")
                        Text(note.note)
                    }.onTapGesture {
                        self.updateNote = note.note
												self.updateNoteID = note.id
                        self.showAddSheet.toggle()
                    }
                }
            }
            .alert( isPresented: $showAlert, content: {
                alert
            })
						.sheet(isPresented: $showAddSheet, onDismiss: fetchNotes, content: {
                if(self.isEditMode == .active){
										UpdateNote(updatedText: $updateNote, updateNoteID: $updateNoteID)
												
										
                } else{
										AddNoteView()
                }
            })
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading,
														content: {
								Button(action: {
										if( self.isEditMode == .active){
												self.isEditMode = .inactive
										}
										else{
												self.isEditMode = .active
										}
								}) {
										self.isEditMode == .active ? Text("Save"): Text("Edit");
								}
						})
                ToolbarItem(placement: .navigationBarTrailing) {
										
										if(self.isEditMode == .active){}
										else{
												Button(action: {
														self.showAddSheet.toggle()
												}) {
														Image(systemName: "note")
														
												}
										}
                }
                
            }
            Text("Select an item")
            
				}.onAppear {
						self.fetchNotes()
				}
    }
    
    func fetchNotes() {
        guard let url = URL(string: "http://192.168.1.6:3000/notes") else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do{
                    let notes = try JSONDecoder().decode([Note].self, from: data)
                    self.notes = notes
                }
                catch {
                    print(error)
                }
            }
        }
        
        task.resume()
				
				if(self.isEditMode == .active){
						self.isEditMode = .inactive
				}
    }
    func deleteNote() {
        guard let id = deleteItem?._id else { return }
        guard let url = URL(string: "http://192.168.1.6:3000/notes/\(id)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            guard err == nil else { return }
            
            
            if let httpResponse = res as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    fetchNotes()
                } else {
                    
                    print("Non-successful status code: \(httpResponse.statusCode)")
                }
            }
        }
        
        task.resume()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

var iso8601DateFormatter: ISO8601DateFormatter {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
}
