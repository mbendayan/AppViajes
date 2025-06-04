package com.appviajes.client;

import static java.lang.String.join;
import static java.time.LocalDateTime.parse;


import com.appviajes.client.apis.GeminiApi;
import com.appviajes.model.dtos.GeminiPromptRequest;
import com.appviajes.model.dtos.PreferenciasRequest;
import com.appviajes.model.entities.Preferences;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelStepEntity;
import java.util.LinkedList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class GeminiClient implements AIClient {

  private final GeminiApi geminiApi;

  private static final String STEPS_CREATION_PROMPT =
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

  @Override
  // TODO: cleanup
  public List<TravelStepEntity> generateTravelSteps(TravelEntity travelEntity) {
    var response = geminiApi.generateContent(new GeminiPromptRequest(buildPrompt(travelEntity)));
    if (response.getStatusCode().is2xxSuccessful() && response.hasBody()) {
      String sanitizedJson = sanitize(response.getBody().getResponse());
      return buildTravelStepEntity(new JSONObject(sanitizedJson).getJSONArray("steps"));
    } else {
      log.error("Error while invoking Gemini API.");
      throw new RuntimeException();
    }
  }

  private List<TravelStepEntity> buildTravelStepEntity(JSONArray steps) {
    List<TravelStepEntity> stepsList = new LinkedList<>();
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
      stepsList.add(stepEntity);
    });
    return stepsList;
  }

  private String buildPrompt(TravelEntity request) {
    String prompt = STEPS_CREATION_PROMPT
        .replace("{destination}", request.getDestination())
        .replace("{startDate}", request.getStartDate().toString())
        .replace("{endDate}", request.getEndDate().toString())
        .replace("{preferences}", buildPreferencesText(request.getPreferences()));

    log.info("Prompt built [{}]", prompt);
    return prompt;
  }

  private String sanitize(String response) {
    return response
        .replace("```", "")
        .replaceFirst("json", "");
  }

private String buildPreferencesText(Preferences prefs) {
  return String.format(
      "presupuesto: %s, monto personalizado: %.2f, tipo viaje: %s, alojamiento: %s, transporte: %s",
      prefs.getPresupuesto() != null ? prefs.getPresupuesto().name() : "Sin especificar",
      prefs.getMontoPersonalizado() != null ? prefs.getMontoPersonalizado() : 0.0,
      prefs.getTipoViaje() != null ? prefs.getTipoViaje().name() : "Sin especificar",
      prefs.getTipoAlojamiento() != null ? prefs.getTipoAlojamiento().name() : "Sin especificar",
      prefs.getTipoTransporte() != null ? prefs.getTipoTransporte().name() : "Sin especificar"
  );
}



}
