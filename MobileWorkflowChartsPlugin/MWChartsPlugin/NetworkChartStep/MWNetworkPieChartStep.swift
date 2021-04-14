//
//  MWNetworkPieChartStep.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 12/02/2021.
//

import Foundation
import MobileWorkflowCore

public class MWNetworkPieChartStep: MWStep, PieChartStep, RemoteContentStep, SyncableContentSource {
   
    public typealias ResponseType = [PieChartItem]
    
    public let stepContext: StepContext
    public let session: Session
    public let services: MobileWorkflowServices
    public let secondaryWorkflowIDs: [String]
    public var contentURL: String?
    public let emptyText: String?
    public var resolvedURL: URL?
    public var items: [PieChartItem] = []
    
    init(identifier: String, stepContext: StepContext, session: Session, services: MobileWorkflowServices, secondaryWorkflowIDs: [String], url: String?, emptyText: String?) {
        self.stepContext = stepContext
        self.session = session
        self.services = services
        self.secondaryWorkflowIDs = secondaryWorkflowIDs
        self.contentURL = url
        self.emptyText = emptyText
        super.init(identifier: identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func instantiateViewController() -> StepViewController {
        MWNetworkPieChartStepViewController(step: self)
    }
    
    public func loadContent(completion: @escaping (Result<[PieChartItem], Error>) -> Void) {
        guard let contentURL = self.contentURL else {
            return completion(.failure(URLError(.badURL)))
        }
        guard let url = self.session.resolve(url: contentURL) else {
            return completion(.failure(URLError(.badURL)))
        }
        do {
            let credential = try self.services.credentialStore.retrieveCredential(.token, isRequired: false).get()
            let task = NetworkPieChartItemTask(input: url, credential: credential)
            self.services.perform(task: task, session: session, completion: completion)
        } catch (let error) {
            completion(.failure(error))
        }
    }
}

extension MWNetworkPieChartStep: MobileWorkflowStep {
    
    public static func build(stepInfo: StepInfo, services: MobileWorkflowServices) throws -> Step {
        
        let url = stepInfo.data.content["url"] as? String
        let emptyText = services.localizationService.translate(stepInfo.data.content["emptyText"] as? String)
        let secondaryWorkflowIDs: [String] = (stepInfo.data.content["workflows"] as? [[String: Any]])?.compactMap({ $0.getString(key: "id") }) ?? []
        
        return MWNetworkPieChartStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, session: stepInfo.session, services: services, secondaryWorkflowIDs: secondaryWorkflowIDs, url: url, emptyText: emptyText)
    }
}
