package io.softwarestrategies.projectx.ui.config

import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository
import org.springframework.security.oauth2.client.web.OAuth2AuthorizedClientRepository
import org.springframework.security.oauth2.client.web.reactive.function.client.ServletOAuth2AuthorizedClientExchangeFilterFunction
import org.springframework.security.web.util.matcher.AntPathRequestMatcher
import org.springframework.web.reactive.function.client.WebClient

@Configuration
@EnableWebSecurity
class ClientSecurityConfig : WebSecurityConfigurerAdapter() {
    @kotlin.Throws(Exception::class)
    protected override fun configure(http: HttpSecurity) { // @formatter:off

        // Redirecting to index page if session become invalidated
        //http.sessionManagement().invalidSessionUrl("/")

        http.authorizeRequests()
                .antMatchers("/").permitAll()
                .anyRequest().authenticated()
                .and()
                .oauth2Login()
                .and()
                .logout()
                    // This line gets rid of the logout confirmation dialog box being shown
                    .logoutRequestMatcher(AntPathRequestMatcher("/logout"))
                    .logoutSuccessUrl("/")
    }

    @org.springframework.context.annotation.Bean
    fun webClient(clientRegistrationRepository: ClientRegistrationRepository?, authorizedClientRepository: OAuth2AuthorizedClientRepository?): WebClient {
        val oauth2 = ServletOAuth2AuthorizedClientExchangeFilterFunction(clientRegistrationRepository, authorizedClientRepository)
        oauth2.setDefaultOAuth2AuthorizedClient(true)
        return WebClient.builder()
                .apply(oauth2.oauth2Configuration())
                .build()
    }
}