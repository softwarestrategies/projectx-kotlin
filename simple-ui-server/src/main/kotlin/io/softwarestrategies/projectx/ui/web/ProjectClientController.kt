package io.softwarestrategies.projectx.ui.web

import io.softwarestrategies.projectx.ui.data.ProjectDto
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.core.ParameterizedTypeReference
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.reactive.function.client.WebClient

@Controller
class ProjectClientController {

    @Value("\${resourceserver.api.project.url:http://localhost:7070/api/projects/}")
    private val projectApiUrl: String? = null

    @Autowired
    private val webClient: WebClient? = null

    @GetMapping("/projects")
    fun getProjects(model: Model): String {
        val projects = webClient!!
                .get()
                .uri(projectApiUrl!!)
                .retrieve()
                .bodyToMono(object : ParameterizedTypeReference<List<ProjectDto?>?>() {}).block()
        model.addAttribute("projects", projects)
        return "projects"
    }

    @GetMapping("/addproject")
    fun addNewProject(model: Model): String {
        model.addAttribute("project", ProjectDto(0L, ""))
        return "addproject"
    }

    @PostMapping("/projects")
    fun saveProject(project: ProjectDto, model: Model): String {
        return try {
            webClient!!.post()
                    .uri(projectApiUrl!!)
                    .bodyValue(project)
                    .retrieve()
                    .bodyToMono(Void::class.java)
                    .block()
            "redirect:/projects"
        } catch (e: Exception) {
            model.addAttribute("msg", e.message)
            "addproject"
        }
    }
}
