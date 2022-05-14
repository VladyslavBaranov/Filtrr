//
//  PaywallView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 21.04.2022.
//

import SwiftUI
import AVKit

struct PricingItem {
    var index: Int
    var price: String
    var title: String
    var subtitle: String
    
    var isSelected = false
	var postDescription: String = ""
}

final class PaywallHostingController: UIHostingController<PaywallView> {
    
    override init(rootView: PaywallView) {
        super.init(rootView: rootView)
        self.rootView.onCloseButtonTapped = dismissSelf
    }
    
    func dismissSelf() {
        dismiss(animated: true)
    }
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct PaywallOptionView: View {
    
    @Binding var selectedItem: Int
    @State var pricingItem: PricingItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(pricingItem.index == selectedItem ? "Radio-2" : "Radio")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 16)
            VStack(alignment: .leading, spacing: 10) {
                Text(pricingItem.title)
                    .font(Font(UIFont(name: "Montserrat-Bold", size: 15) ?? .systemFont(ofSize: 15)))
                Text(pricingItem.subtitle)
                    .font(Font(UIFont(name: "Montserrat-Regular", size: 10) ?? .systemFont(ofSize: 10)))
                    .foregroundColor(pricingItem.index == selectedItem ? Color(uiColor: .appAccent) : Color(uiColor: .lightGray))
            }
            Spacer()
            HStack(spacing: 3) {
                Text("$")
                    .font(Font(Montserrat.regular(size: 10)))
                    .offset(x: 0, y: -4)
                Text("\(pricingItem.price)")
                    .font(Font(Montserrat.semibold(size: 20)))
                Text("/m")
                    .font(Font(Montserrat.regular(size: 10)))
                    .offset(x: 0, y: 5)
            }
            .offset(x: 0, y: -10)
            .padding(.trailing, 16)
            
        }
        .frame(height: 75)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(UIColor.appAccent), lineWidth: pricingItem.index == selectedItem ? 1 : 0)
        )
        .background(
            pricingItem.index == selectedItem ? Color(uiColor: .appDark).cornerRadius(16) : Color(uiColor: .appGray).cornerRadius(16))
        .padding([.leading, .trailing], 30)
        .onTapGesture {
            selectedItem = pricingItem.index
            pricingItem.isSelected.toggle()
        }
    }
}

struct PaywallView: View {
    
    let model: PlayerViewModel
    var onCloseButtonTapped: (() -> ())?
    
    init() {
        model = PlayerViewModel(fileName: "PaywallVid")
    }
    
    @State var selectedItem: Int = 0
    @State var pricingItems: [PricingItem] = [
		.init(
            index: 0,
            price: "5.99",
            title: LocalizationManager.shared.localizedString(for: .settingsYearTitle),
            subtitle: LocalizationManager.shared.localizedString(for: .settingsYearCaption),
            postDescription: LocalizationManager.shared.localizedString(for: .settingsYearPriceFull)
        ),
        .init(
            index: 1,
            price: "4.99",
            title: LocalizationManager.shared.localizedString(for: .settings6MonthTitle),
            subtitle: LocalizationManager.shared.localizedString(for: .settings6MonthCapion),
            postDescription: LocalizationManager.shared.localizedString(for: .settings6MonthFull)
        ),
		.init(
            index: 2,
            price: "6.99",
            title: LocalizationManager.shared.localizedString(for: .settingsMonthTitle),
            subtitle: LocalizationManager.shared.localizedString(for: .settingsMonthCaption),
            isSelected: true
        ),
    ]
    
    private func clampOffset(_ reader: GeometryProxy) -> CGFloat {
        let offset = reader.frame(in: .global).minY
        return offset < 0 ? 0 : offset
    }
    
    private func clampOffset2(_ reader: GeometryProxy) -> CGFloat {
        let offset = reader.frame(in: .global).minY
        return offset > 0 ? -offset : 0
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { reader in
                ZStack {
                    PlayerContainerView(player: model.player, gravity: .aspectFill)
                    VStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 10) {
                            Text(AttributedString(getFiltrrPremiumString()))
                                .foregroundColor(.white)
                                .font(Font(UIFont(name: "Montserrat-Bold", size: 32) ?? .systemFont(ofSize: 32)))
                            Text(LocalizationManager.shared.localizedString(for: .settingsCardCaption))
                                .lineLimit(2)
                                .foregroundColor(.white)
                                .font(Font(UIFont(name: "Montserrat-Regular", size: 13) ?? .systemFont(ofSize: 13)))
                        }
                        .padding(30)
                    }
                    VStack {
                        HStack {
                            Button {
                                model.pause()
                                // model.player.removeAllItems()
                                onCloseButtonTapped?()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title)
                                    .padding(EdgeInsets(top: 45, leading: 20, bottom: 0, trailing: 0))
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }.ignoresSafeArea()
                    .frame(
                        width: reader.frame(in: .global).width,
                        height: reader.frame(in: .global).height + clampOffset(reader)
                    )
                    .offset(y: clampOffset2(reader))
            }.frame(height: UIScreen.main.bounds.height / 2)
            
            ZStack {
                VStack(alignment: .center, spacing: 16) {
                    PaywallOptionView(selectedItem: $selectedItem, pricingItem: pricingItems[0])
                        .padding(.top, 40)
                    PaywallOptionView(selectedItem: $selectedItem, pricingItem: pricingItems[1])
                    PaywallOptionView(selectedItem: $selectedItem, pricingItem: pricingItems[2])
                    Spacer(minLength: 120)
                }
                
                VStack(alignment: .center) {
                    Spacer()
                    Button {
                        print("Subscribe")
                    } label: {
                        Text(LocalizationManager.shared.localizedString(for: .settingsSubscribNow))
                            .foregroundColor(.white)
                            .font(Font(Montserrat.semibold(size: 17)))
                            .frame(width: UIScreen.main.bounds.width - 120, height: 60)
                            .background(Color(uiColor: .appAccent))
                            .cornerRadius(30)
                    }
                    Text(pricingItems[selectedItem].postDescription)
                        .font(Font(Montserrat.regular(size: 13)))
                    
                }
                .padding(Edge.Set.bottom, 40)
            }
        }.ignoresSafeArea()
    }
    
    func getFiltrrPremiumString() -> NSAttributedString {
        let string = NSMutableAttributedString()
        let filtrrString = NSAttributedString(string: "filtrr", attributes: [
            .font: Montserrat.bold(size: 32)
        ])
        string.append(filtrrString)
        let premiumString = NSAttributedString(string: " premium", attributes: [
            .font: Montserrat.light(size: 32)
        ])
        string.append(premiumString)
        return string
    }
}
