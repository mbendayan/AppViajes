package com.appviajes.model.dtos;

import java.util.List;

public record GeminiPromptResponse(List<GeminiPromptCandidates> candidates) {

  // TODO: improve/beautify
  public String getResponse() {
    return candidates.get(0).content.parts.get(0).text;
  }

  public record GeminiPromptCandidates(GeminiPromptCandidatesContent content) { }

  public record GeminiPromptCandidatesContent(List<GeminiPromptContentParts> parts) { }

  public record GeminiPromptContentParts(String text) { }
}
