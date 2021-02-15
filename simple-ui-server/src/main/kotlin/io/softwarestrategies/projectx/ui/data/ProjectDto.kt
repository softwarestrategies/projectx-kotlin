package io.softwarestrategies.projectx.ui.data

class ProjectDto {
    var id: Long? = null
    var name: String? = null

    constructor() {}
    constructor(id: Long?, name: String?) : super() {
        this.id = id
        this.name = name
    }

    override fun hashCode(): Int {
        val prime = 31
        var result = 1
        result = prime * result + if (id == null) 0 else id.hashCode()
        result = prime * result + if (name == null) 0 else name.hashCode()
        return result
    }

    override fun equals(obj: Any?): Boolean {
        if (this === obj) return true
        if (obj == null) return false
        if (javaClass != obj.javaClass) return false
        val other = obj as ProjectDto
        if (id == null) {
            if (other.id != null) return false
        } else if (id != other.id) return false
        if (name == null) {
            if (other.name != null) return false
        } else if (name != other.name) return false
        return true
    }

    override fun toString(): String {
        return "Project [id=$id, name=$name]"
    }
}