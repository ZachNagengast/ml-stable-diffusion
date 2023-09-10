// For licensing see accompanying LICENSE.md file.
// Copyright (C) 2022 Apple Inc. All Rights Reserved.

import Foundation
import CoreGraphics

/// Type of processing that will be performed to generate an image
public enum PipelineMode {
    case textToImage
    case imageToImage
    // case inPainting
}

/// Image generation configuration
open class PipelineConfiguration {

    /// Text prompt to guide sampling
    public var prompt: String
    /// Negative text prompt to guide sampling
    public var negativePrompt: String = ""
    /// Starting image for image2image or in-painting
    public var startingImage: CGImage? = nil
    /// Fraction of inference steps to be used in `.imageToImage` pipeline mode
    /// Must be between 0 and 1
    /// Higher values will result in greater transformation of the `startingImage`
    public var strength: Float = 1.0
    /// Number of images to generate
    public var imageCount: Int = 1
    /// Number of inference steps to perform
    public var stepCount: Int = 50
    /// Random seed which to start generation
    public var seed: UInt32 = 0
    /// Controls the influence of the text prompt on sampling process (0=random images)
    public var guidanceScale: Float = 7.5
    /// List of Images for available ControlNet Models
    public var controlNetInputs: [CGImage] = []
    /// Enables progress updates to decode `currentImages` from denoised latent images for better previews
    public var useDenoisedIntermediates: Bool = false
    /// The type of Scheduler to use.
    public var schedulerType: StableDiffusionScheduler = .pndmScheduler
    /// The type of RNG to use
    public var rngType: StableDiffusionRNG = .numpyRNG
    /// Safety checks are only performed if `self.canSafetyCheck && !disableSafety`
    public var disableSafety: Bool = false

    /// Given the configuration, what mode will be used for generation
    public var mode: PipelineMode {
        guard startingImage != nil else {
            return .textToImage
        }
        guard strength < 1.0 else {
            return .textToImage
        }
        return .imageToImage
    }

    public init(
        prompt: String
    ) {
        self.prompt = prompt
    }

    public func asSDConfiguration() -> PipelineConfigurationSD {
        // Setup defaults for standard config
        let config = PipelineConfigurationSD(prompt: self.prompt)

        // Copy common properties
        config.negativePrompt = self.negativePrompt
        config.startingImage = self.startingImage
        config.strength = self.strength
        config.imageCount = self.imageCount
        config.stepCount = self.stepCount
        config.seed = self.seed
        config.guidanceScale = self.guidanceScale
        config.controlNetInputs = self.controlNetInputs
        config.useDenoisedIntermediates = self.useDenoisedIntermediates
        config.schedulerType = self.schedulerType
        config.rngType = self.rngType
        config.disableSafety = self.disableSafety

        return config
    }

    public func asXLConfiguration() -> PipelineConfigurationXL {
        // Setup defaults for XL config
        let xlConfig = PipelineConfigurationXL(prompt: self.prompt)

        // Copy common properties
        xlConfig.negativePrompt = self.negativePrompt
        xlConfig.startingImage = self.startingImage
        xlConfig.strength = self.strength
        xlConfig.imageCount = self.imageCount
        xlConfig.stepCount = self.stepCount
        xlConfig.seed = self.seed
        xlConfig.guidanceScale = self.guidanceScale
        xlConfig.controlNetInputs = self.controlNetInputs
        xlConfig.useDenoisedIntermediates = self.useDenoisedIntermediates
        xlConfig.schedulerType = self.schedulerType
        xlConfig.rngType = self.rngType
        xlConfig.disableSafety = self.disableSafety

        return xlConfig
    }

}

public class PipelineConfigurationSD: PipelineConfiguration {
    /// Scale factor to use on the latent after encoding
    public var encoderScaleFactor: Float32 = 0.18215
    /// Scale factor to use on the latent before decoding
    public var decoderScaleFactor: Float32 = 0.18215
}


@available(iOS 16.2, macOS 13.1, *)
public extension StableDiffusionPipeline {

    /// Type of processing that will be performed to generate an image
    typealias Mode = PipelineMode

    /// Image generation configuration
    typealias Configuration = PipelineConfigurationSD
}
