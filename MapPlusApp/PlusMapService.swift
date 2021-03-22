//
//  PlusMapService.swift
//  
//
//  Created by Daeho Kim on 09.03.21.
//

import Foundation
import Combine
import MapTiles
import Gzip

struct AvailableMap: Decodable {
    var TicId: String
    var Name: String
    var DataVersion: String
    var NetworkCreateTime: Date
    var Description: String
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

public class PlusMapService: ObservableObject {
    @Published var requestedTiles: [VMapTile] = []
    @Published var availableMap: [AvailableMap] = []
    var canceleable: AnyCancellable?
    
    let urlPlusMap: String = "https://plusmapservice.gewi.com/tic3plusmapserviceapp/"
    
    public init() {
        
    }
    
    public func updateMapTiles(textInput: String) {
        guard let url = URL(string: urlPlusMap + textInput) else {
            fatalError("Invalid URL")
        }
        
        canceleable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [String].self, decoder: JSONDecoder())
            .map { $0.compactMap({ t in self.convert(tileData: t) } ) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                }
            }, receiveValue: { mapTiles in
                self.requestedTiles = mapTiles
                print("\(mapTiles.count)")
            })
    }
    
    private func convert(tileData: String) -> VMapTile? {
        if let binaryCompressed = Data(base64Encoded: tileData, options: []) {
            if let decompressed = try? binaryCompressed.gunzipped() {
                let data = BinaryData(data: decompressed)
                return VMapTile.readFromStream(data: data)
            }
        }
        return nil
    }
    
    public func updateAvailableMap(textInput: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        guard let url = URL(string: urlPlusMap + textInput) else {
            fatalError("Invalid URL")
        }
        
        canceleable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [AvailableMap].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                }
            }, receiveValue: { result in
                self.availableMap = result
                print(result)
            })
    }
}

