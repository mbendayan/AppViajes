package com.appviajes.client;

import com.appviajes.client.apis.GeminiApi;
import com.appviajes.model.dtos.GeminiPromptRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class GeminiClient implements AIClient {

  private final GeminiApi geminiApi;

  public String generateAIResponse(String prompt) {
    var response = geminiApi.generateContent(new GeminiPromptRequest(prompt));
    if (response.getStatusCode().is2xxSuccessful() && response.hasBody()) {
      return sanitize(response.getBody().getResponse());
    } else {
      // TODO:
      log.error("Error while invoking Gemini API.");
      throw new RuntimeException();
    }
  }

  private String sanitize(String response) {
    return response
        .replace("```", "")
        .replaceFirst("json", "");
  }
}
