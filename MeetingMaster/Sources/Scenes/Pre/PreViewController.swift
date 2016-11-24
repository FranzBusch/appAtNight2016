//
//  PreViewController.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import UIKit

class PreViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var participantViews: [ParticipantView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        MeetingController.sharedInstance.updateMeeting()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        EventBus<MeetingUpdatedEvent>.register(self, handler: meetingUpdated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)

        EventBus<MeetingUpdatedEvent>.unregister(self)
    }

    func meetingUpdated(_ event: MeetingUpdatedEvent) {
        tableView.reloadData()
        setupParticipantViews()
    }


    func setupParticipantViews() {
        guard let participants = MeetingController.sharedInstance.currentMeeting?.presentParticipants else {
            return
        }


        for (index, participant) in participants.enumerated() {
            participantViews[index].isHidden = false
            participantViews[index].jobLabel.text = participant.job
            participantViews[index].nameLabel.text = participant.name
            switch participant.name {
            case "Donald Trump":
                participantViews[index].participantImageView.image = #imageLiteral(resourceName: "5")
            case "Angela Merkel":
                    participantViews[index].participantImageView.image = #imageLiteral(resourceName: "2")
            case "Justin Trudeau":
                participantViews[index].participantImageView.image = #imageLiteral(resourceName: "1")
            case "Wladimir Putin":
                participantViews[index].participantImageView.image = #imageLiteral(resourceName: "3")
            case "Xi Jinping":
                participantViews[index].participantImageView.image = #imageLiteral(resourceName: "6")
            case "Theresa May":
                participantViews[index].participantImageView.image = #imageLiteral(resourceName: "4")
            default:
                break
            }
            participantViews[index].participantImageView.state = .green
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension PreViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MeetingController.sharedInstance.currentMeeting?.travellingParticipants.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell") as! ParticipantTableViewCell

        var sortedParticipants = MeetingController.sharedInstance.currentMeeting?.travellingParticipants.sorted { $0.0.eta > $0.1.eta }.sorted { $0.0.status == .accepted }

        guard let participant = sortedParticipants?[indexPath.row] else {
            return cell
        }

        cell.backgroundView = nil
        cell.backgroundColor = UIColor.clear
        cell.nameLabel.text = participant.name
        cell.jobTitleLabel.text = participant.job
        switch participant.name {
        case "Donald Trump":
            cell.participantImageView.image = #imageLiteral(resourceName: "5")
        case "Angela Merkel":
            cell.participantImageView.image = #imageLiteral(resourceName: "2")
        case "Justin Trudeau":
            cell.participantImageView.image = #imageLiteral(resourceName: "1")
        case "Wladimir Putin":
            cell.participantImageView.image = #imageLiteral(resourceName: "3")
        case "Xi Jinping":
            cell.participantImageView.image = #imageLiteral(resourceName: "6")
        case "Theresa May":
            cell.participantImageView.image = #imageLiteral(resourceName: "4")
        default:
            break
        }

        cell.participantImageView.state = participant.status == .accepted ? .orange : .red
        cell.etaLabel.text = participant.status == .accepted ? participant.eta.asStringHHmmss : ""

        return cell
    }

}
