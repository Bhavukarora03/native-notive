import SwiftUI

struct AddNoteView: View {
		@State var text = ""
		@State private var isFocused: Bool = false
		@FocusState private var focusedField: Bool
		
		@Environment(\.presentationMode) var presentationMode
		var body: some View {
				NavigationView{
						VStack {
								Form {
										Text("Add a Note")
												.font(.headline).padding()
										TextEditor(text: $text)
												.frame(minHeight: 200)
												.padding()
												.focused($focusedField)
										
										HStack{
												Spacer()
												Button(action: postNotes) {
														Text("Save")
																.foregroundColor(.white)
																.frame(maxWidth: 100)
																.padding()
																.background(Color.blue)
																.cornerRadius(50)
												}.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
										}
										
								}
	
						}
				}.onAppear {
						focusedField = true
				}
				
		}
		
		func postNotes(){
				let params = ["note": text] as [String: Any]
				
				guard let url = URL(string: "http://192.168.1.6:3000/notes") else { return }
				
				let session = URLSession.shared
				
				var request = URLRequest(url: url)
				
				request.httpMethod = "POST"
				
				do{
						request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
				}
				catch let error{
						print(error)
				}
				
				request.addValue("application/json", forHTTPHeaderField: "Content-Type")
				request.addValue("application/json", forHTTPHeaderField: "Accept")
				
				let task = session.dataTask(with: request) { data, res, err in
						guard  err == nil else {return}
						
						guard let data = data else {return}
						
						do{
								if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]{
										print(json)
								}
						}
						catch let err{
								print(err)
						}
				}
				task.resume()
				self.text = ""
				presentationMode.wrappedValue.dismiss()
				
		}
}

struct AddNoteView_Previews: PreviewProvider {
		static var previews: some View {
				AddNoteView()
		}
}
