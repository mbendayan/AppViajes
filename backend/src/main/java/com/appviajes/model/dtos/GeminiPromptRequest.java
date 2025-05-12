package com.appviajes.model.dtos;

import java.util.List;

public record GeminiPromptRequest(List<Content> contents) {

  public GeminiPromptRequest(String prompt) {
    this(List.of(new Content(List.of(new Part(prompt)))));
  }

  public record Content(List<Part> parts) { }

  public record Part(String text) { }
}
