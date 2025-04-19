//
//  ShowsListCollectionViewCell.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import UIKit
import Kingfisher
import Common
import Domain

final class ShowsListCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "ShowCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    func configure(with show: Show) {
        nameLabel.text = show.name
        guard
            let imageURLStr: String = show.image?.medium,
            let url: URL = URL(string: imageURLStr) else { return }
        let processor: ImageProcessor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.setImage(with: url,
                              options: [.processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(0.3)),
                                        .cacheOriginalImage])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
}

extension ShowsListCollectionViewCell: ViewCoding {
    func setupHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.4),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
