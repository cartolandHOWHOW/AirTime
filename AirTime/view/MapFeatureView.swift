//
//  MapFeatureView.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//
import SwiftUI
import MapKit

struct MapFeatureView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        Map(coordinateRegion: $locationManager.region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .constant(.follow))
        .ignoresSafeArea()
        .navigationTitle("我的旅遊定位")
    }
}

