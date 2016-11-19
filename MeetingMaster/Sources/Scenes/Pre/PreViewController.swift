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
    }

}

extension PreViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MeetingController.sharedInstance.currentMeeting?.participants.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell") as! ParticipantTableViewCell

        guard let participant = MeetingController.sharedInstance.currentMeeting?.participants[indexPath.row] else {
            return cell
        }

        cell.nameLabel.text = participant.name
        cell.jobTitleLabel.text = participant.job
        cell.participantImageView.image = UIImage(named: "trump")
        cell.etaLabel.text = String(participant.eta)

        return cell
    }

}
