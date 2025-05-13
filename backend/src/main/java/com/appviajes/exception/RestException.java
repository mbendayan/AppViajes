package com.appviajes.exception;

import com.appviajes.model.enums.ErrorEnum;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class RestException extends RuntimeException {

  private final ErrorEnum errorEnum;
}
