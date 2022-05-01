package com.dongwon.book.springboot;

import com.dongwon.book.springboot.domain.posts.Posts;
import com.dongwon.book.springboot.domain.posts.PostsRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class IndexControllerTest {
    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private PostsRepository postsRepository;

    @Test
    public void 메인페이지_로딩() {
        //when
        String body = this.restTemplate.getForObject("/", String.class);

        //then
        assertThat(body).contains("스프링 부트로 시작하는 웹 서비스");
    }

    @Test
    public void Posts_조회된다() throws Exception {
        //given
        int n = 10;
        List<Posts> savedPostsList = new ArrayList<>();
        for (int i = 1; i <= n; i++) {
            savedPostsList.add(
                    postsRepository.save(Posts.builder()
                    .title("title" + i)
                    .content("content" + i)
                    .author("author" + i)
                    .build()));
        }

        String url = "http://localhost:" + port + "/";

        //when
        String body = this.restTemplate.getForObject("/", String.class);

        //then
        for (int i = 0; i < savedPostsList.size(); i++) {
            assertThat(body).contains(savedPostsList.get(i).getTitle());
            assertThat(body).contains(savedPostsList.get(i).getAuthor());
        }
    }
}
