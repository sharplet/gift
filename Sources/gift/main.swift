import ArgumentParser
import SwiftIO

extension Path: ExpressibleByArgument {}

struct Gift: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Convert a video to a GIF using ffmpeg."
  )

  @Option(help: "The framerate of the resulting GIF.")
  var framerate: Int = 15

  @Option(
    name: [.customShort("w"), .long],
    help: "Maximum width, preserving aspect ratio."
  )
  var maxWidth: Int = 512

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
      "-r", "\(framerate)",
      "-filter:v", "scale=\(maxWidth):-1,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse",
      outputPath.rawValue
    )
  }
}

Gift.main()
