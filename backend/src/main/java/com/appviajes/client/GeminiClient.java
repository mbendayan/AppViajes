package com.appviajes.client;

import static java.time.LocalDateTime.parse;


import com.appviajes.client.apis.GeminiApi;
import com.appviajes.model.dtos.GeminiPromptRequest;
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

  public String generateRecommendations(TravelEntity travel) {
    String prompt = buildRecommendationPrompt(travel);
    var response = geminiApi.generateContent(new GeminiPromptRequest(prompt));
    if (response.getStatusCode().is2xxSuccessful() && response.hasBody()) {
      return sanitize(response.getBody().getResponse());
    } else {
      log.error("Error generando recomendaciones con Gemini.");
      throw new RuntimeException("Error al obtener recomendaciones del viaje");
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
        .replace("{preferences}", request.getPreferences());

    log.info("Prompt built [{}]", prompt);
    return prompt;
  }

  public List<TravelStepEntity> generateNewTravelSteps(TravelEntity travelEntity) {
    String prompt = buildNewTravelStepsPrompt(travelEntity);
    var response = geminiApi.generateContent(new GeminiPromptRequest(prompt));

    if (response.getStatusCode().is2xxSuccessful() && response.hasBody()) {
        String sanitizedJson = sanitize(response.getBody().getResponse());
        return buildTravelStepEntity(new JSONObject(sanitizedJson).getJSONArray("steps"));
    } else {
        log.error("Error generando nuevas actividades con Gemini.");
        throw new RuntimeException("Error al obtener nuevas actividades");
    }
}


  private String buildNewTravelStepsPrompt(TravelEntity travel){
    return """
        Necesito que generes una lista de actividades (30 actividades) a modo de itinerario recomendadas para un viaje a {destination}, desde {startDate} hasta {endDate} basadas en estas preferencias: {preferences}. Que incluya excursiones, actividades, visitas, etc. 
         Responde en este JSON format:
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
        """
        .replace("{destination}", travel.getDestination())
        .replace("{startDate}" , travel.getStartDate().toString())
        .replace("{endDate}", travel.getEndDate().toString())
        .replace("{preferences}", travel.getPreferences())
        ;
  }
  private String buildRecommendationPrompt(TravelEntity travel) {
    return """
        Necesito que generes una serie de recomendaciones para un viaje a {destination}, desde {startDate} hasta {endDate}.

        Quiero que las recomendaciones estén organizadas por secciones claras, con títulos destacados. Deben estar redactadas en tono amigable, como si le hablaras a un viajero.

        Las secciones que quiero son:

        1. Ropa adecuada: según el clima estimado en ese lugar y fechas, recomendaciones de abrigo, ropa liviana, impermeable, etc. Especificar si va a llover.
        2. Elementos útiles: paraguas, protector solar, adaptadores para enchufes.
        3. Transporte: Apps de transporte y cómo funciona el transporte público (por ejemplo, si hay SUBE en Buenos Aires, Oyster en Londres, etc.)
        4. Actividades recomendadas: eventos que ocurran en las fechas del viaje o actividades de interes para turistas.
        5. Gastronomía local recomendada: platos típicos, restaurantes bien puntuados, y opciones de restaurantes bien puntuados que sirvan comida sin tacc, vegetariana y vegana.

        No incluyas recomendaciones médicas ni de salud ni vacunas.

        Escribí las recomendaciones como si fueran parte de una guía de viaje personalizada para un usuario real.
        """
        .replace("{destination}", travel.getDestination())
        .replace("{startDate}", travel.getStartDate().toLocalDate().toString())
        .replace("{endDate}", travel.getEndDate().toLocalDate().toString());
  }

  private String sanitize(String response) {
    return response
        .replace("```", "")
        .replaceFirst("json", "");
  }


private String buildPreferencesText(Preferences prefs) {
  return String.format(
      "presupuesto: %s, monto personalizado: %.2f, tipo viaje: %s, alojamiento: %s, transporte: %s",
      prefs.getPresupuesto() != null ? prefs.getPresupuesto() : "Sin especificar",
      prefs.getTipoViaje() != null ? prefs.getTipoViaje() : "Sin especificar",
      prefs.getTipoAlojamiento() != null ? prefs.getTipoAlojamiento() : "Sin especificar",
      prefs.getTipoTransporte() != null ? prefs.getTipoTransporte() : "Sin especificar"
  );
}
}
