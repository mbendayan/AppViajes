package com.appviajes.model.enums;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorEnum {
  TRAVEL_NOT_FOUND(404);

  private final HttpStatus status;

  ErrorEnum(int code) {
    this.status = HttpStatus.resolve(code);
  }
}
