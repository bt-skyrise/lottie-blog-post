//
//  ViewController.swift
//  LottieSkyriseLoaderExample
//
//  Created by Kamil Chlebuś on 02/01/2019.
//  Copyright © 2019 Skyrise. All rights reserved.
//

import UIKit
import Lottie

final class AnimationViewController: UIViewController {

    private lazy var imageView: UIImageView = makeImageView()
    private lazy var loaderLabel: UILabel = makeLabel(withText: "Loader")
    private lazy var progressLabel: UILabel = makeLabel(withText: "Progress")
    private lazy var loaderAnimationView: LOTAnimationView = LOTAnimationView(name: "skyrise-loader")
    private lazy var progressAnimationView: LOTAnimationView = LOTAnimationView(name: "skyrise-loader")
    private lazy var downloadButton: UIButton = makeDownloadButton()

    private let imageURL: URL =  URL(string: "https://unsplash.com/photos/bhSNKT5aaMc/download?force=true")!
    private let downloadQueue = OperationQueue()
    private var downloadTask: URLSessionDownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @objc
    func didTapDownloadButton() {
        loaderAnimationView.play()
        startDownload()
    }

    func startDownload() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: downloadQueue)
        downloadTask = session.downloadTask(with: imageURL)
        downloadTask?.resume()
        print("Downloading...")
    }

}

extension AnimationViewController: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
            setImageWithAnimation(image)
        }
        DispatchQueue.main.async {
            self.loaderAnimationView.pause()
            self.loaderAnimationView.loopAnimation = false
            self.loaderAnimationView.play(toProgress: 1) { [weak self] (_) in
                self?.loaderAnimationView.loopAnimation = true
            }
        }
        print("Download complete")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        let percentValue = ((progress * 100) * 10).rounded() / 10
        print("\(percentValue)%")
        progressAnimationView.animationProgress = progress
    }

}

private extension AnimationViewController {

    func setImageWithAnimation(_ image: UIImage?) {
        DispatchQueue.main.async {
            UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.imageView.image = image
            })
        }
    }

}

private extension AnimationViewController {

    func configureUI() {
        addSubviews()
        makeConstraints()
        loaderAnimationView.loopAnimation = true
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }

    func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(loaderLabel)
        view.addSubview(progressLabel)
        view.addSubview(loaderAnimationView)
        view.addSubview(progressAnimationView)
        view.addSubview(downloadButton)
    }

    func makeConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        loaderLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        loaderAnimationView.translatesAutoresizingMaskIntoConstraints = false
        progressAnimationView.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),

            loaderLabel.centerXAnchor.constraint(equalTo: loaderAnimationView.centerXAnchor),
            loaderLabel.bottomAnchor.constraint(equalTo: loaderAnimationView.topAnchor, constant: 45),

            progressLabel.centerXAnchor.constraint(equalTo: progressAnimationView.centerXAnchor),
            progressLabel.bottomAnchor.constraint(equalTo: progressAnimationView.topAnchor, constant: 45),

            loaderAnimationView.leftAnchor.constraint(equalTo: downloadButton.leftAnchor, constant: -30),
            loaderAnimationView.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -20),

            progressAnimationView.rightAnchor.constraint(equalTo: downloadButton.rightAnchor, constant: 30),
            progressAnimationView.bottomAnchor.constraint(equalTo: loaderAnimationView.bottomAnchor),

            imageView.bottomAnchor.constraint(equalTo: loaderLabel.topAnchor, constant: -30),

            downloadButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            downloadButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
            downloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

}

private extension AnimationViewController {

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image-placeholder")
        return imageView
    }

    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }

    func makeDownloadButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Start download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17.0)
        button.backgroundColor = UIColor(red: 29.0/255.0, green: 233.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12.0
        button.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        return button
    }

}
