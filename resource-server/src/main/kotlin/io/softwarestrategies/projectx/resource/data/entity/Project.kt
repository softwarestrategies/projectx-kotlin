package io.softwarestrategies.projectx.resource.data.entity

import com.fasterxml.jackson.annotation.JsonIgnore
import org.springframework.data.annotation.*
import org.springframework.data.relational.core.mapping.Column
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDateTime


@Table("project")
class Project public constructor() {

    @Id
    var id: Long? = null

    @Version
    @Column("version")
    var version: Int = 0

    @CreatedDate
    @JsonIgnore
    @Column("created_on")
    var createdOn: LocalDateTime = LocalDateTime.now()

    @LastModifiedDate
    @JsonIgnore
    @Column("modified_on")
    var modifiedOn: LocalDateTime = LocalDateTime.now()

    @CreatedBy
    @JsonIgnore
    @Column("created_by")
    var createdBy: String? = "TODO"

    @LastModifiedBy
    @JsonIgnore
    @Column("modified_by")
    var modifiedBy: String? = "TODO"

    @Column("name")
    var name: String? = null

    @Column("description")
    var description: String? = null

    @Column("user_id")
    var userId: Long? = null

    @Column("status")
    var status: Status? = null

    public enum class Status private constructor(val abbreviation: String?) {
        NEW("N"),
        PENDING("P"),
        ACTIVE("A"),
        INACTIVE("I"),
        OPEN("O"),
        CLOSED("C"),
        DELETED("D");

        companion object {
            fun fromAbbreviation(code: String): Status {
                for (status in values()) {
                    if (status.abbreviation == code) {
                        return status
                    }
                }
                throw UnsupportedOperationException(
                        "The code $code is not supported!")
            }
        }
    }
}

