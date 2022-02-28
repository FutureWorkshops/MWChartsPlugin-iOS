//
//  MWNetworkDashboardStep.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 28/02/2022.
//

import Foundation
import MobileWorkflowCore

public struct NetworkDashboardItemTask: CredentializedAsyncTask, URLAsyncTaskConvertible {
    public typealias Response = [DashboardItem]
    public let input: URL
    public let credential: Credential?
}

public class MWNetworkDashboardStep: MWStep, DashboardStep, RemoteContentStep, SyncableContentSource {
   
    public typealias ResponseType = [DashboardItem]
    
    public let stepContext: StepContext
    public let session: Session
    public let services: StepServices
    public var contentURL: String?
    public let emptyText: String?
    public var resolvedURL: URL?
    public var items: [DashboardItem] = []
    
    init(identifier: String, stepContext: StepContext, session: Session, services: StepServices, url: String?, emptyText: String?) {
        self.stepContext = stepContext
        self.session = session
        self.services = services
        self.contentURL = url
        self.emptyText = emptyText
        super.init(identifier: identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func instantiateViewController() -> StepViewController {
        MWNetworkDashboardStepViewController(step: self)
    }
    
    public func loadContent(completion: @escaping (Result<[DashboardItem], Error>) -> Void) {
        guard let contentURL = self.contentURL else {
            return completion(.failure(URLError(.badURL)))
        }
        guard let url = self.session.resolve(url: contentURL) else {
            return completion(.failure(URLError(.badURL)))
        }
        do {
            let credential = try self.services.credentialStore.retrieveCredential(.token, isRequired: false).get()
            let task = NetworkDashboardItemTask(input: url, credential: credential)
            self.services.perform(task: task, session: session, completion: completion)
        } catch (let error) {
            completion(.failure(error))
        }
    }
}

extension MWNetworkDashboardStep: BuildableStep {
    
    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        
        let url = stepInfo.data.content["url"] as? String
        let emptyText = services.localizationService.translate(stepInfo.data.content["emptyText"] as? String)

        return MWNetworkDashboardStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, session: stepInfo.session, services: services, url: url, emptyText: emptyText)
    }
}
