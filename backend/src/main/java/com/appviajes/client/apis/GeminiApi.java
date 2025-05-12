package com.appviajes.client.apis;

import com.appviajes.model.dtos.GeminiPromptRequest;
import com.appviajes.model.dtos.GeminiPromptResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "geminiClient", url = "${gemini.url}")
public interface GeminiApi {

  @PostMapping(value = ":generateContent", consumes = "application/json")
  ResponseEntity<GeminiPromptResponse> generateContent(
      @RequestBody GeminiPromptRequest request
  );
}
