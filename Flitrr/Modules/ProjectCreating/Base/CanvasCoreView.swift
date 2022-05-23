//
//  ProjectTransparentGridView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

final class Canvas: UIView {
    
    static var renderSize: CGSize = .zero
    
    private var gridView: GridView!
    
    var canvas: CanvasCoreView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gridView = GridView(frame: bounds)
        gridView.backgroundColor = .clear
        addSubview(gridView)
        canvas = CanvasCoreView(frame: bounds)
        canvas.bakgroundMode = .plainColor(.clear)
        addSubview(canvas)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridView.frame = bounds
        canvas.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderPNG() -> Data? {
        canvas.createPNG()
    }
    
    func add(_ adjustable: AdjustableView) {
        canvas.adjustables.append(adjustable)
        canvas.addSubview(adjustable)
        canvas.setNeedsDisplay()
    }
    
    func remove(_ adjustable: AdjustableView) {
        adjustable.removeFromSuperview()
        canvas.adjustables.removeAll { $0.id == adjustable.id }
    }
}

final class CanvasCoreView: AdjustableView {
    
    enum BackgroundMode {
        case plainColor(UIColor)
        case image(UIImage)
        case gradient([UIColor])
    }
    
    var adjustables: [AdjustableView] = []
    var trashButton: UIButton!
    
    var bakgroundMode = BackgroundMode.plainColor(.clear) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func add(_ adjustable: AdjustableView) {
        adjustables.append(adjustable)
        addSubview(adjustable)
        setNeedsDisplay()
    }
    
    func remove(_ adjustable: AdjustableView) {
        adjustable.removeFromSuperview()
        adjustables.removeAll { $0.id == adjustable.id }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        trashButton = UIButton()
        trashButton.setImage(UIImage(systemName: "trash"), for: .normal)
        trashButton.frame.size = .init(width: 40, height: 40)
        trashButton.layer.cornerRadius = 20
        trashButton.layer.cornerCurve = .continuous
        trashButton.tintColor = .white
        trashButton.backgroundColor = UIColor.systemGray5
        trashButton.addTarget(self, action: #selector(handleTrash), for: .touchUpInside)
        addSubview(trashButton)
        hideTrash()
    }
    
    @objc func handleTrash() {
        for adjustable in adjustables {
            if adjustable.gridIsActive {
                adjustable.removeFromSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trashButton.center = .init(x: bounds.midX, y: bounds.height - 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        switch bakgroundMode {
        case .plainColor(let uIColor):
            uIColor.setFill()
            UIRectFill(bounds)
        case .image(let uIImage):
            uIImage.draw(in: bounds)
        case .gradient(let colors):
            let cgColors = colors.map { $0.cgColor }
            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: cgColors as CFArray, locations: nil) else { return }
            ctx.drawLinearGradient(
                gradient,
                start: .zero, end: .init(x: rect.width, y: rect.height),
                options: []
            )
        }
        
    }
    
    func prepareForRendering() {
        gridIsActive = false
        for adjustable in adjustables {
            adjustable.gridIsActive = false
        }
    }
    
    func createPNG() -> Data? {
        UIGraphicsBeginImageContext(Canvas.renderSize)
        print("#", Canvas.renderSize)
        drawHierarchy(in: .init(origin: .zero, size: Canvas.renderSize), afterScreenUpdates: false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        
        return image?.pngData()
    }
    
    func hideTrash() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            trashButton.alpha = 0
        } completion: { [unowned self] _ in
            trashButton.isHidden = true
        }
    }
    
    func showTrash() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            trashButton.alpha = 1
        } completion: { [unowned self] _ in
            trashButton.isHidden = false
        }
    }
}
