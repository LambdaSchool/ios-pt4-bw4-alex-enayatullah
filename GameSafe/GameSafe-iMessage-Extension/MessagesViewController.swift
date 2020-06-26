//
//  MessagesViewController.swift
//  GameSafe-iMessage-Extension
//
//  Created by Alex Shillingford on 6/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        
        removeAllChildViewControllers()
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        
        guard let conversation = activeConversation else { fatalError("Expected an active conversation.") }
        
        if conversation.localParticipantIdentifier == conversation.selectedMessage?.senderParticipantIdentifier {
            presentViewController(for: conversation, with: presentationStyle)
        }
    }
    
    /// - Tag: Add ability to actually display message from 
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        removeAllChildViewControllers()
        
        let controller = instantiateDecoyViewController()
        
        
        if presentationStyle == .expanded {
            addChild(controller)
            controller.view.frame = view.bounds
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            
            NSLayoutConstraint.activate([
                controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                controller.view.topAnchor.constraint(equalTo: view.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            
            controller.didMove(toParent: self)
        } else {
            addChild(controller)
            controller.view.frame = view.bounds
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            
            NSLayoutConstraint.activate([
                controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                controller.view.topAnchor.constraint(equalTo: view.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            
            controller.didMove(toParent: self)
        }
    }
    
    private func instantiateDecoyViewController() -> UIViewController {
        let controller = DecoyViewController()
//        addChild(controller)
        
        controller.view.frame = self.view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "GamePlayWaiting")!
        
        let imageView = UIImageView(image: image) as UIView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        controller.view.addSubview(imageView)
        
        let aspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: (1.0 / 1.0), constant: 0)
        imageView.addConstraint(aspectRatioConstraint)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: controller.view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: controller.view.rightAnchor),
            imageView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor),
            aspectRatioConstraint
        ])

        
        return controller
    }
    
    private func removeAllChildViewControllers() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    fileprivate func composeMessage() -> MSMessage {
        let layout = MSMessageTemplateLayout()
        layout.image = UIImage(named: "GameSafe-Logo")!
        layout.caption = "GameSafe Play Invite"
        
        let message = MSMessage(session: MSSession())
        message.layout = layout
        
        return message
    }
}
