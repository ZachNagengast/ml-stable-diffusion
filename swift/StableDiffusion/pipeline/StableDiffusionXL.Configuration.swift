// For licensing see accompanying LICENSE.md file.
// Copyright (C) 2023 Apple Inc. All Rights Reserved.

import Foundation
import CoreGraphics
import CoreML

public class PipelineConfigurationXL: PipelineConfiguration {
    /// Scale factor to use on the latent after encoding
    public var encoderScaleFactor: Float32 = 0.13025
    /// Scale factor to use on the latent before decoding
    public var decoderScaleFactor: Float32 = 0.13025
    /// Fraction of inference steps to at which to start using the refiner unet if present in `textToImage` mode
    /// Must be between 0 and 1
    /// Higher values will result in fewer refiner steps
    public var refinerStart: Float = 0.7
    /// If `originalSize` is not the same as `targetSize` the image will appear to be down- or upsampled.
    /// Part of SDXL’s micro-conditioning as explained in section 2.2 of https://huggingface.co/papers/2307.01952.
    public var originalSize: Float32 = 1024
    /// `cropsCoordsTopLeft` can be used to generate an image that appears to be “cropped” from the position `cropsCoordsTopLeft` downwards.
    /// Favorable, well-centered images are usually achieved by setting `cropsCoordsTopLeft` to (0, 0).
    public var cropsCoordsTopLeft: Float32 = 0
    /// For most cases, `target_size` should be set to the desired height and width of the generated image.
    public var targetSize: Float32 = 1024
    /// Used to simulate an aesthetic score of the generated image by influencing the positive text condition.
    public var aestheticScore: Float32 = 6
    /// Can be used to simulate an aesthetic score of the generated image by influencing the negative text condition.
    public var negativeAestheticScore: Float32 = 2.5
}

@available(iOS 17.0, macOS 14.0, *)
public extension StableDiffusionXLPipeline {

    /// Type of processing that will be performed to generate an image
    typealias Mode = PipelineMode
}



