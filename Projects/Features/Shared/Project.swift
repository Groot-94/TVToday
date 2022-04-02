import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Shared",
  resources: ["Resources/**"],
  dependencies: [
    .package(product: "Kingfisher"),
    .project(
      target: "UI",
      path: .relativeToRoot("Projects/Features/UI")
    ),
    .project(
      target: "Networking",
      path: .relativeToRoot("Projects/Features/Networking")
    ),
    .project(
      target: "KeyChainStorage",
      path: .relativeToRoot("Projects/Features/KeyChainStorage")
    )
  ]
)
