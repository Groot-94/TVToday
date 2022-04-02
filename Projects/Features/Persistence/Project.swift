import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Persistence",
  dependencies: [
    .project(
      target: "Shared",
      path: .relativeToRoot("Projects/Features/Shared")
    )
  ]
)
