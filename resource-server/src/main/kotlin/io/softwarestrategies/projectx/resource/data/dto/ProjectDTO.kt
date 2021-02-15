package io.softwarestrategies.projectx.resource.data.dto

import io.softwarestrategies.projectx.resource.data.entity.Project

class ProjectDTO public constructor() {

    var id: Long = 0
    var name: String? = null
    var description: String? = null
    var userId: Long? = null
    var status: Project.Status? = null
}
