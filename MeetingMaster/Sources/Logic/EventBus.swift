//
//  EventBus.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Foundation

public protocol Event {

}

public class EventBus<EventType: Event> {

    fileprivate var listeners = [EventListener<EventType>]()
    public typealias EventListenerClosure = (_ event: EventType) -> Void

}

// MARK: public interface
public extension EventBus {

    static func registerOnBackground(_ observer: AnyObject, handler: @escaping EventListenerClosure) {
        let queue = DispatchQueue(label :"com.sixt.Eventbus" + String(describing: EventType.self))
        register(observer, onQueue: queue, handler: handler)
    }

    static func register(_ observer: AnyObject, onQueue queue: DispatchQueue = .main, handler: @escaping EventListenerClosure) {
        onInstance { $0.register(observer, onQueue: queue, handler: handler) }
    }

    static func post(_ event: EventType) {
        onInstance { $0.post(event) }
    }

    static func unregister(_ observer: AnyObject) {
        onInstance { $0.unregister(observer) }
    }

}

// MARKL: instantiation
fileprivate extension EventBus {

    static func onInstance(_ execute: @escaping (EventBus<EventType>) -> Void ) {
        EventBusStorage.queue.async(flags: .barrier) {
            for case let bus as EventBus<EventType> in EventBusStorage.buses {
                execute(bus)
                return
            }

            let bus = EventBus<EventType>()
            EventBusStorage.buses.append(bus)
            execute(bus)
        }
    }

}

// MARK: private helpers
fileprivate extension EventBus {

    func register(_ observer: AnyObject, onQueue queue: DispatchQueue, handler: @escaping EventListenerClosure) {
        EventBusStorage.queue.async(flags: .barrier) {
            self.listeners.append(EventListener<EventType>(observer, queue, handler))
        }
    }

    func post(_ event: EventType) {
        EventBusStorage.queue.async {
            for listener in self.listeners {
                listener.post(event)
            }
        }
    }

    func unregister(_ observer: AnyObject) {
        EventBusStorage.queue.async(flags: .barrier) {
            self.listeners = self.listeners.filter { $0.observer !== observer }
        }
    }

}

// MARK: subscriber holder
fileprivate class EventListener<EventType: Event> {

    typealias EventListenerClosure = EventBus<EventType>.EventListenerClosure
    weak var observer: AnyObject?
    let queue: DispatchQueue
    let handler: EventListenerClosure
    let eventClassName: String

    init(_ observer: AnyObject, _ queue: DispatchQueue, _ handler: @escaping EventListenerClosure) {
        self.observer = observer
        self.handler = handler
        self.queue = queue
        self.eventClassName = String(describing: observer)
    }

    func post(_ event: EventType) {
        guard let _ = observer else {
            fatalError("One of observers did not unregister, but already dealocated, observer info: " + eventClassName)
        }

        queue.async {
            self.handler(event)
        }
    }

}

fileprivate struct EventBusStorage {

    static let queue = DispatchQueue(label: "com.sixt.EventBus", attributes: .concurrent)
    static var buses = [AnyObject]()
    
}
