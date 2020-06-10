import ArgumentParser
import SwiftIO

extension Path: ExpressibleByArgument {}

struct Gift: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Convert a video to a GIF using ffmpeg."
  )

  @Option(default: 15, help: "The framerate of the resulting GIF.")
  var framerate: Int

  @Option(default: 512, help: "Maximum width, preserving aspect ratio.")
  var maxWidth: Int

  @Option(
    name: [.short, .customLong("output")],
    help: """
    A custom path to save the GIF to.
    (default: same as <input> with extension .gif)
    """
  )
  var outputPath: Path!

  @Argument(help: .init("", valueName: "input"))
  var inputPath: Path

  mutating func run() throws {
    if outputPath == nil {
      outputPath = inputPath
      outputPath.extension = "gif"
    }

    try exec(
      "ffmpeg",
      "-i", inputPath.rawValue,
      "-framerate", "\(framerate)",
      "-filter:v", "scale=\(maxWidth):-1,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse",
      outputPath.rawValue
    )
  }
}

Gift.main()
