package io.softwarestrategies.projectx.resource.web

import io.softwarestrategies.projectx.resource.data.entity.Project
import io.softwarestrategies.projectx.resource.exception.EntityNotFoundException
import io.softwarestrategies.projectx.resource.service.ProjectService
import kotlinx.coroutines.flow.Flow
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*


@RestController
@RequestMapping("/api/projects")
class ProjectApiController @Autowired constructor(val projectService: ProjectService) {

    @GetMapping
    suspend fun findAll(@RequestParam("filters") filters: String?): ResponseEntity<Flow<Project>> {
        return ResponseEntity(projectService.findAll(filters), HttpStatus.OK)
    }

    @GetMapping("/{id}")
    suspend fun findById(@PathVariable id: Long): ResponseEntity<Project> {
        try {
            return ResponseEntity(projectService.findById(id), HttpStatus.OK)
        }
        catch (enfe: EntityNotFoundException) {
            return ResponseEntity(HttpStatus.NOT_FOUND)
        }
    }

    @PostMapping
    suspend fun save(@RequestBody project: Project): ResponseEntity<Project> {
        return ResponseEntity(projectService.save(project), HttpStatus.CREATED)
    }

    @DeleteMapping("/{id}")
    suspend fun delete(@PathVariable id: Long): ResponseEntity<HttpStatus> {
        projectService.delete(id)
        return ResponseEntity(HttpStatus.NO_CONTENT)
    }
}