//
//  channelsPage.swift
//  mvc
//
//  Created by Anton on 10/7/2025.
//

import SwiftUI

struct ChannelsPage: View {
    @ObservedObject var messagesModel: MessagesModel
    let summary = "insert summary here"
    var onChannelSelect: (_ channelName:String) -> Void
    @State private var enterChannelPresenting = false
    var body: some View {
        VStack {
            Text("Channels")
            ZStack(alignment: .bottomTrailing){
                List {
                    ForEach(messagesModel.channels().lazy.map { channel in channel.channelName }, id: \.self) { channel in
                        HStack {
                            Text(channel)
                                .padding(.horizontal, 20)
                            Text(summary)
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }
                        .padding(.vertical, 20)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onChannelSelect(channel)
                        }
                    }
                }
                Button(action: {enterChannelPresenting.toggle()}) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .center)
                        .foregroundStyle(Color.blue)
                        .padding(.trailing,50)
                        .padding(.bottom, 50)
                }.popover(isPresented: $enterChannelPresenting) {
                    HalfScreenSheetView { channel in
                        if channel == "" {
                            return
                        }
                        print("He entered", channel)
                        onChannelSelect(channel)
                        enterChannelPresenting.toggle()
                    }
                        .presentationDetents([.fraction(0.5)])
                }

            }
        }
    }
}

struct HalfScreenSheetView: View {
    var updateChannel: (String) -> Void
    @State private var enteredChannel = ""
    var body: some View {
        VStack {
            Text("Enter Channel")
                .font(.title)
                .padding()
            Text("This channel will be added to your channel list")
            Spacer()
            TextField("enter channel ID", text: $enteredChannel)
                .padding()
                .textFieldStyle(.roundedBorder)
            Button("Start Chatting") {
                updateChannel(enteredChannel)
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding() // Inner padding
            .background(Color.blue)
            .cornerRadius(15)
            .padding(.horizontal)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
            Spacer()
            
        }
    }
}

//#Preview {
//    ChannelsPage(channels: ["Antons", "Haeli's"], onChannelSelect: {i in})
//}
