import UIKit

extension UIView {
    
    enum Edge: CaseIterable {
        case top
        case bottom
        case leading
        case trailing
    }
    
    func pinTop(to view: UIView, _ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
    }
    
    func pinLeading(to view: UIView, _ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant).isActive = true
    }
    
    func pinTrailing(to view: UIView, _ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constant).isActive = true
    }
    
    func pinBottom(to view: UIView, _ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
    }
    
    func pinVertical(to view: UIView, _ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
    }
    
    func pinHorizontal(to view: UIView, _ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constant).isActive = true
    }
    
    func pinCenter(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    func pinCenterX(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    func pinCenterY(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    func pinTopToBottom(of view: UIView, constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
    }
    
    func pinBottomToTop(of view: UIView, constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -constant).isActive = true
    }
    
    func pinEdges(_ edges: [Edge], to view: UIView, constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        for edge in edges {
            switch edge {
            case .top:
                topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
            case .leading:
                leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant).isActive = true
            case .trailing:
                trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constant).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
            }
        }
    }
    
    func pinHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func pinWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
