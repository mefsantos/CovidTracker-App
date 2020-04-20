/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSLoadingView: UIView {
    private let errorStackView = UIStackView()
    private let loadingIndicatorView = NSAnimatedGraphView()

    private let errorTitleLabel = NSLabel(.subtitle, textAlignment: .center)
    private let errorTextLabel = NSLabel(.text, textAlignment: .center)
    private let reloadButton = NSButton(title: "loading_view_reload".ub_localized)

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        backgroundColor = .ns_background
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    public func startLoading() {
        alpha = 1.0
        errorStackView.alpha = 0.0
        loadingIndicatorView.alpha = 1.0

        loadingIndicatorView.startAnimating()
    }

    public func stopLoading(error: Error? = nil, reloadHandler: (() -> Void)? = nil) {
        loadingIndicatorView.stopAnimating()

        if let err = error {
            errorTextLabel.text = err.localizedDescription
            reloadButton.touchUpCallback = reloadHandler
            loadingIndicatorView.alpha = 0.0
            errorStackView.alpha = 1.0
        } else {
            alpha = 0.0
        }
    }

    private func setup() {
        addSubview(loadingIndicatorView)

        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }

        addSubview(errorStackView)

        errorStackView.snp.makeConstraints { make in
            make.edges.lessThanOrEqualToSuperview().inset(NSPadding.large).priority(.low)
            make.centerY.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().inset(NSPadding.large)
        }

        errorTitleLabel.text = "loading_view_error_title".ub_localized

        errorStackView.axis = .vertical
        errorStackView.spacing = NSPadding.medium
        errorStackView.alignment = .center

        errorStackView.addArrangedSubview(errorTitleLabel)
        errorStackView.addArrangedSubview(errorTextLabel)
        errorStackView.addArrangedSubview(reloadButton)

        errorStackView.alpha = 0.0
        alpha = 0.0
    }
}
