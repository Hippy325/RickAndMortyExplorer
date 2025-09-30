//
//  CharacterListRouter.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 26.09.2025.
//

import UIKit

class SlideFromBottomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        
        toView.frame = finalFrame.offsetBy(dx: 0, dy: containerView.frame.height)
        containerView.addSubview(toView)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toView.frame = finalFrame
                fromView.alpha = 0.7
            }, completion: { _ in
                fromView.alpha = 1.0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}

class CharacterListNavigationDelegate: NSObject, UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return SlideFromBottomTransition()
        }
        return nil
    }
}

protocol ICharacterListRouter {
    func showCharacterDetail(with index: Int)
}

final class CharacterListRouter: ICharacterListRouter {
    
    weak var viewController: UIViewController?
    private let detailCharacterAssembly: IDetailCharacterViewAssembly
    private let navigationDelegate = CharacterListNavigationDelegate()
    
    init(detailCharacterAssembly: IDetailCharacterViewAssembly) {
        self.detailCharacterAssembly = detailCharacterAssembly
    }
    
    func showCharacterDetail(with id: Int) {
        let detailViewController = detailCharacterAssembly.assembly(id)
        viewController?.navigationController?.delegate = navigationDelegate
        viewController?.navigationController?.navigationBar.isHidden = false
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
