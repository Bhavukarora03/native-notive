import SwiftUI

struct UpdateNote: View {
		
		@Binding var updatedText: String
		@Binding var updateNoteID : String
		@Environment(\.presentationMode) var presentationMode
		
		var body: some View {
				NavigationView{
						VStack {
								Form {
										Text("update a Note")
												.font(.headline).padding()
										TextEditor(text: $updatedText)
												.frame(minHeight: 200)
												.padding()
										
										HStack{
												Spacer()
												Button(action: updateNoteCallback) {
														Text("Update")
																.foregroundColor(.white)
																.frame(maxWidth: 100)
																.padding()
																.background(Color.blue)
																.cornerRadius(50)
												}.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
										}
										
								}
								
						}
				}
		}
		
		func updateNoteCallback(){
				print("Hello world")
				let params = ["note": updatedText] as [String: Any]

				guard let url = URL(string: "http://192.168.1.6:3000/notes/\(updateNoteID)") else { return }

				let session = URLSession.shared

				var request = URLRequest(url: url)

				request.httpMethod = "PATCH"

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
				presentationMode.wrappedValue.dismiss()
				
		}
}

