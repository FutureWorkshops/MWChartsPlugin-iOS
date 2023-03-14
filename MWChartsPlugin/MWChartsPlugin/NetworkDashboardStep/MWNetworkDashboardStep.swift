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
    
    public static var mandatoryCodingPaths: [CodingKey] {
        ["url"] // see 'loadContent'
    }
    
    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        
        let url = stepInfo.data.content["url"] as? String
        let emptyText = services.localizationService.translate(stepInfo.data.content["emptyText"] as? String)
        let numberOfColumns = (stepInfo.data.content["numberOfColumns"] as? String)?.toInt() ?? 1 // default to 1 column

        return MWNetworkDashboardStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, session: stepInfo.session, services: services, url: url, emptyText: emptyText, numberOfColumns: numberOfColumns)
    }
}

public class ChartsNetworkDashboardMetadata: StepMetadata {
    enum CodingKeys: String, CodingKey {
        case url
        case emptyText
        case navigationItems = "_navigationItems"
        case numberOfColumns
    }
    
    let url: String
    let emptyText: String?
    let navigationItems: [NavigationItemMetadata]?
    let numberOfColumns: String?
    
    init(id: String, title: String, url: String, emptyText: String?, navigationItems: [NavigationItemMetadata]?, numberOfColumns: String?, next: PushLinkMetadata?, links: [LinkMetadata]) {
        self.url = url
        self.emptyText = emptyText
        self.navigationItems = navigationItems
        self.numberOfColumns = numberOfColumns
        super.init(id: id, type: "io.app-rail.charts.network-dashboard", title: title, next: next, links: links)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        self.emptyText = try container.decodeIfPresent(String.self, forKey: .emptyText)
        self.navigationItems = try container.decodeIfPresent([NavigationItemMetadata].self, forKey: .navigationItems)
        self.numberOfColumns = try container.decodeIfPresent(String.self, forKey: .numberOfColumns)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.url, forKey: .url)
        try container.encodeIfPresent(self.emptyText, forKey: .emptyText)
        try container.encodeIfPresent(self.navigationItems, forKey: .navigationItems)
        try container.encodeIfPresent(self.numberOfColumns, forKey: .numberOfColumns)
        try super.encode(to: encoder)
    }
}

public extension StepMetadata {
    static func chartsNetworkDashboard(
        id: String,
        title: String,
        url: String,
        emptyText: String? = nil,
        navigationItems: [NavigationItemMetadata]? = nil,
        numberOfColumns: String? = nil,
        next: PushLinkMetadata? = nil,
        links: [LinkMetadata] = []
    ) -> ChartsNetworkDashboardMetadata {
        ChartsNetworkDashboardMetadata(id: id, title: title, url: url, emptyText: emptyText, navigationItems: navigationItems, numberOfColumns: numberOfColumns, next: next, links: links)
    }
}
