package com.appviajes.service;

import static com.appviajes.util.JsonUtils.toJson;
import static java.lang.String.join;
import static java.time.LocalDateTime.parse;

import com.appviajes.client.AIClient;
import com.appviajes.model.dtos.CreateTravelRequest;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelStepEntity;
import com.appviajes.repository.TravelJpaRepository;
import java.time.LocalDateTime;
import java.util.LinkedList;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class TravelService {

  private final AIClient aiClient;
  private final TravelJpaRepository travelRepository;

  // TODO: propertify
  private static final String stepsCreationPrompt =
      """
          Create a travel itinerary to {destination} from {startDate} to {endDate}, based on these preferences: {preferences}. Include enough steps (activities, excursions, etc.) to cover that time.
          Respond in this JSON format:
              {
                "steps": [
                  {
                    "description": "",
                    "startDate": "", // format ISO_LOCAL_DATE_TIME
                    "endDate": "", // format ISO_LOCAL_DATE_TIME
                    "location": "",
                    "name": "",
                    "cost": 0.0,
                    "recommendations": ""
                  }
                ]
              }
          """;

  public TravelEntity createTravel(CreateTravelRequest request) {
    String prompt = buildPrompt(request);
    String response = sendPrompt(prompt);
    TravelEntity createdEntity = buildTravelEntity(request, new JSONObject(response));
    return travelRepository.save(createdEntity);
  }

  private String buildPrompt(CreateTravelRequest request) {
    String prompt = stepsCreationPrompt
        .replace("{destination}", request.destination())
        .replace("{startDate}", request.startDate().toString())
        .replace("{endDate}", request.endDate().toString())
        .replace("{preferences}", join(",", request.preferences()));
    log.info("Prompt built [{}]", prompt);
    return prompt;
  }

  private String sendPrompt(String prompt) {
    String response = aiClient.generateAIResponse(prompt);
    log.info("AI response [{}]", response);
    return response;
  }

  private TravelEntity buildTravelEntity(CreateTravelRequest request, JSONObject json) {
    TravelEntity travelEntity = buildAndSaveTravelEntity(request);
    buildAndSaveTravelStepEntity(travelEntity, json.getJSONArray("steps"));
    log.info("TravelEntity built [{}]", toJson(travelEntity));
    return travelEntity;
  }

  private TravelEntity buildAndSaveTravelEntity(CreateTravelRequest request) {
    TravelEntity travelEntity = new TravelEntity();
    travelEntity.setName(request.name());
    travelEntity.setPreferences(join(",", request.preferences()));
    travelEntity.setDestination(request.destination());
    travelEntity.setCreationDate(LocalDateTime.now());
    travelEntity.setSteps(new LinkedList<>());
    return travelEntity;
  }

  private void buildAndSaveTravelStepEntity(TravelEntity travelEntity, JSONArray steps) {
    steps.forEach(step -> {
      JSONObject stepJson = new JSONObject(step.toString());
      TravelStepEntity stepEntity = new TravelStepEntity();
      stepEntity.setCost(stepJson.getBigDecimal("cost"));
      stepEntity.setName(stepJson.getString("name"));
      stepEntity.setLocation(stepJson.getString("location"));
      stepEntity.setStartDate(parse(stepJson.getString("startDate")));
      stepEntity.setEndDate(parse(stepJson.getString("endDate")));
      stepEntity.setDescription(stepJson.getString("description"));
      stepEntity.setRecommendations(stepJson.getString("recommendations"));
      travelEntity.getSteps().add(stepEntity);
    });
  }
}
