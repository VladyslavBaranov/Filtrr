//
//  PaywallView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 21.04.2022.
//  95,88

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
    
    var showsDiscount: Bool
    @Binding var selectedItem: Int
    @State var pricingItem: AppProduct
    
    var body: some View {
        ZStack {
            HStack(spacing: 16) {
                Image(pricingItem.index == selectedItem ? "Radio-2" : "Radio")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 16)
                VStack(alignment: .leading, spacing: 10) {
                    Text(pricingItem.getTitle())
                        .font(Font(UIFont(name: "Montserrat-Bold", size: 15) ?? .systemFont(ofSize: 15)))
                    //if showsDiscount {
                    //    Text("Participate in contest and get iPhone 13 PRO MAX")
                    //        .font(Font(UIFont(name: "Montserrat-Bold", size: 15) ?? .systemFont(ofSize: 15)))
                    //}
                    Text(pricingItem.getSubtitle())
                        .font(Font(UIFont(name: "Montserrat-Medium", size: 12) ?? .systemFont(ofSize: 12)))
                        .foregroundColor(pricingItem.index == selectedItem ? Color(uiColor: .appAccent) : Color(uiColor: .lightGray))
                }
                .padding([.bottom, .top], 16)
                Spacer()
                VStack(alignment: .trailing, spacing: 1.5) {
                    Text(pricingItem.getPrice())
                        .font(Font(Montserrat.semibold(size: 22)))
                    HStack(spacing: 3) {
                        Text("\(pricingItem.getMonthlyPrice())")
                            .font(Font(Montserrat.medium(size: 16)))
                        Text(LocalizationManager.shared.localizedString(for: .paywallM))
                            .font(Font(Montserrat.medium(size: 12)))
                            .offset(x: 0, y: 2)
                    }.foregroundColor(Color(UIColor.lightGray))
                }
                
                //.offset(x: 0, y: -10)
                .padding(.all, 16)
                
            }
            
            // .frame(height: 75)
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
            if showsDiscount {
                VStack {
                    HStack {
                        Spacer()
                        Text(LocalizationManager.shared.localizedString(for: .saveUpTo22))
                            .font(Font(Montserrat.medium(size: 12)))
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color(UIColor.appAccent))
                            .cornerRadius(3)
                    }
                    .padding([.leading, .trailing], 50)
                    Spacer()
                }
                .offset(x: 0, y: -11)
            }
        }
    }
}

struct PaywallView: View {
    
    @State var dismissButtonOpacity: CGFloat = 0.0
    
    @ObservedObject
    var storeHelper = StoreHelper()
    
    @State var isPrivacyPolicyPresented = false
    @State var isTermsOfUsePresented = false
    
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
                VStack {
                    VStack(alignment: .center, spacing: 16) {
                        PaywallOptionView(
                            showsDiscount: true, selectedItem: $selectedItem,
                            pricingItem: storeHelper.products[0])
                            .padding(.top, 40)
                        PaywallOptionView(
                            showsDiscount: false, selectedItem: $selectedItem,
                            pricingItem: storeHelper.products[1])
                        PaywallOptionView(
                            showsDiscount: false, selectedItem: $selectedItem,
                            pricingItem: storeHelper.products[2])
                        Spacer(minLength: 10)
                    }
                    
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
                    
                    HStack(spacing: 30) {
                        Button {
                            isTermsOfUsePresented = true
                        } label: {
                            Text(LocalizationManager.shared.localizedString(for: .termsOfUse))
                                .foregroundColor(Color(UIColor.label))
                                .font(Font(Montserrat.medium(size: 13)))
                                .underline()
                        }.sheet(isPresented: $isTermsOfUsePresented) {
                            PrivacyPolicyView(mode: .termsOfUse)
                        }
                        Button {
                            isPrivacyPolicyPresented = true
                        } label: {
                            Text(LocalizationManager.shared.localizedString(for: .settingsPrivacy))
                                .foregroundColor(Color(UIColor.label))
                                .font(Font(Montserrat.medium(size: 13)))
                                .underline()
                        }.sheet(isPresented: $isPrivacyPolicyPresented) {
                            PrivacyPolicyView(mode: .privacyPolicy)
                        }
                    }
                    .padding(.bottom, 40)
                    
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
