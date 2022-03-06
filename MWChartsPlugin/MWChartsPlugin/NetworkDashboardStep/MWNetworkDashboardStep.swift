//
//  MWNetworkDashboardStep.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 28/02/2022.
//

import Foundation
import MobileWorkflowCore

public struct NetworkDashboardStepItemTask: CredentializedAsyncTask, URLAsyncTaskConvertible {
    public typealias Response = [DashboardStepItem]
    public let input: URL
    public let credential: Credential?
}

public class MWNetworkDashboardStep: MWStep, DashboardStep, RemoteContentStep, SyncableContentSource {
   
    public typealias ResponseType = [DashboardStepItem]
    
    public let stepContext: StepContext
    public let session: Session
    public let services: StepServices
    public var contentURL: String?
    public let emptyText: String?
    public let numberOfColumns: Int
    public var resolvedURL: URL?
    public var items: [DashboardStepItem] = []
    
    init(identifier: String, stepContext: StepContext, session: Session, services: StepServices, url: String?, emptyText: String?, numberOfColumns: Int) {
        self.stepContext = stepContext
        self.session = session
        self.services = services
        self.contentURL = url
        self.emptyText = emptyText
        self.numberOfColumns = numberOfColumns
        super.init(identifier: identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func instantiateViewController() -> StepViewController {
        MWNetworkDashboardStepViewController(step: self)
    }
    
    public func loadContent(completion: @escaping (Result<[DashboardStepItem], Error>) -> Void) {
        guard let contentURL = self.contentURL else {
            return completion(.failure(URLError(.badURL)))
        }
        guard let url = self.session.resolve(url: contentURL) else {
            return completion(.failure(URLError(.badURL)))
        }
        do {
            let credential = try self.services.credentialStore.retrieveCredential(.token, isRequired: false).get()
            let task = NetworkDashboardStepItemTask(input: url, credential: credential)
            self.services.perform(task: task, session: session, completion: completion)
        } catch (let error) {
            completion(.failure(error))
        }
    }
}

extension String {
    func toDouble() -> Double? {
        return Double(self)
    }
}

extension String {
    func toInt() -> Int? {
        return Int(self)
    }
}

extension MWNetworkDashboardStep: BuildableStep {
    
    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        
        let url = stepInfo.data.content["url"] as? String
        let emptyText = services.localizationService.translate(stepInfo.data.content["emptyText"] as? String)
        let numberOfColumns = (stepInfo.data.content["numberOfColumns"] as? String)?.toInt() ?? 1 // default to 1 column

        return MWNetworkDashboardStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, session: stepInfo.session, services: services, url: url, emptyText: emptyText, numberOfColumns: numberOfColumns)
    }
}
