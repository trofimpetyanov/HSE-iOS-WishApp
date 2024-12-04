import EventKit

protocol CalendarManaging {
    func create(eventModel: CalendarEvent, completion: ((Bool) -> Void)?)
}

final class CalendarManager: CalendarManaging {
    private let eventStore: EKEventStore = EKEventStore()
    
    func create(eventModel: CalendarEvent, completion: ((Bool) -> Void)? = nil) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self else {
                completion?(false)
                return
            }
            let event: EKEvent = EKEvent(eventStore: self.eventStore)
            event.title = eventModel.title
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            event.notes = eventModel.note
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            do {
                try self.eventStore.save(event, span: .thisEvent)
            } catch let error as NSError {
                print("failed to save event with error : \(error)")
                completion?(false)
            }
            completion?(true)
        }
        
        eventStore.requestFullAccessToEvents(completion: createEvent)
    }
}
