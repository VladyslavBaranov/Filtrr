//
//  PaywallView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 21.04.2022.
//

import SwiftUI
import AVKit

final class PaywallHostingController: UIHostingController<PaywallView> {
    
    override init(rootView: PaywallView) {
        super.init(rootView: rootView)
        self.rootView.onCloseButtonTapped = dismissSelf
        StoreObserver.shared.finishedCallback = { [unowned self] in
            dismiss(animated: true)
        }
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
    @State var pricingItem: AppProduct
    
    var body: some View {
        HStack(spacing: 16) {
            Image(pricingItem.index == selectedItem ? "Radio-2" : "Radio")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 16)
            VStack(alignment: .leading, spacing: 10) {
                Text(pricingItem.getTitle())
                    .font(Font(UIFont(name: "Montserrat-Bold", size: 15) ?? .systemFont(ofSize: 15)))
                Text(pricingItem.getSubtitle())
                    .font(Font(UIFont(name: "Montserrat-Medium", size: 12) ?? .systemFont(ofSize: 12)))
                    .foregroundColor(pricingItem.index == selectedItem ? Color(uiColor: .appAccent) : Color(uiColor: .lightGray))
            }
            Spacer()
            HStack(spacing: 3) {
                Text("\(pricingItem.getMonthlyPrice())")
                    .font(Font(Montserrat.semibold(size: 25)))
                Text(LocalizationManager.shared.localizedString(for: .paywallM))
                    .font(Font(Montserrat.medium(size: 13)))
                    .offset(x: 0, y: 5)
            }
            //.offset(x: 0, y: -10)
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
    
    @State var dismissButtonOpacity: CGFloat = 0.0
    
    @ObservedObject
    var storeHelper = StoreHelper()
    
    @State var isPrivacyPolicyPresented = false
    
    let model: PlayerViewModel
    var onCloseButtonTapped: (() -> ())?
    
    init() {
        model = PlayerViewModel(fileName: "PaywallVid")
    }
    
    @State var selectedItem: Int = 0
    
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
                                    .opacity(dismissButtonOpacity)
                            }
                            Spacer()
                            Button {
                                storeHelper.restore()
                            } label: {
                                Text(LocalizationManager.shared.localizedString(for: .settingsRestore))
                                    .foregroundColor(.white)
                                    .font(Font(Montserrat.semibold(size: 14)))
                                    .padding(EdgeInsets(top: 45, leading: 0, bottom: 0, trailing: 20))
                            }
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
            
            if !storeHelper.products.isEmpty {
                ZStack {
                    VStack(alignment: .center, spacing: 16) {
                        PaywallOptionView(
                            selectedItem: $selectedItem,
                            pricingItem: storeHelper.products[0])
                            .padding(.top, 40)
                        PaywallOptionView(
                            selectedItem: $selectedItem,
                            pricingItem: storeHelper.products[1])
                        PaywallOptionView(
                            selectedItem: $selectedItem,
                            pricingItem: storeHelper.products[2])
                        Spacer(minLength: 150)
                    }
                    
                    VStack(alignment: .center) {
                        Spacer()
                        Button {
                            storeHelper.buy(product: storeHelper.products[selectedItem].skProduct)
                        } label: {
                            Text(LocalizationManager.shared.localizedString(for: .settingsSubscribNow))
                                .foregroundColor(.white)
                                .font(Font(Montserrat.semibold(size: 17)))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color(uiColor: .appAccent))
                                .cornerRadius(30)
                                .padding([.leading, .trailing], 50)
                        }
                        Text(storeHelper.products[selectedItem].getDescription())
                            .font(Font(Montserrat.semibold(size: 24)))
                        
                    }
                    .padding(Edge.Set.bottom, 40)
                    
                    VStack {
                        Spacer()
                        Button {
                            isPrivacyPolicyPresented = true
                        } label: {
                            Text(LocalizationManager.shared.localizedString(for: .settingsPrivacy))
                                .foregroundColor(Color(UIColor.label))
                                .font(Font(Montserrat.medium(size: 13)))
                                .underline()
                        }.sheet(isPresented: $isPrivacyPolicyPresented) {
                            PrivacyPolicyView()
                        }
                    }
                }
            } else {
                VStack(alignment: .center) {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .frame(height: 200)
            }
        }.ignoresSafeArea()
            .onAppear {
                withAnimation(.linear(duration: 0.3).delay(2)) {
                    dismissButtonOpacity = 1
                }
            }
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
