package io.softwarestrategies.projectx.ui

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class SimpleUiServerApplication

fun main(args: Array<String>) {
	runApplication<SimpleUiServerApplication>(*args)
}
