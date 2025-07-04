package com.appviajes.client;

import static java.time.LocalDateTime.parse;


import com.appviajes.client.apis.GeminiApi;
import com.appviajes.model.dtos.GeminiPromptRequest;
import com.appviajes.model.dtos.TravelRecommendationsDto;
import com.appviajes.model.entities.Preferences;
import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelStepEntity;

import java.util.ArrayList;
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

public TravelRecommendationsDto generateRecommendations(TravelEntity travel) {
    String prompt = buildRecommendationPrompt(travel);
    var response = geminiApi.generateContent(new GeminiPromptRequest(prompt));

    if (response.getStatusCode().is2xxSuccessful() && response.hasBody()) {
        String json = sanitize(response.getBody().getResponse());
        JSONObject jsonObject = new JSONObject(json);

        TravelRecommendationsDto dto = new TravelRecommendationsDto();
        dto.setTemperatura(jsonObject.getString("Temperatura"));
        dto.setVestimenta(jsonArrayToList(jsonObject.getJSONArray("Vestimenta")));
        dto.setEsenciales(jsonArrayToList(jsonObject.getJSONArray("Esenciales")));
        dto.setTransporte(jsonArrayToList(jsonObject.getJSONArray("Transporte")));
        dto.setActividades(jsonArrayToList(jsonObject.getJSONArray("Actividades")));
        dto.setGastronomia(jsonArrayToList(jsonObject.getJSONArray("Gastronomia")));

        return dto;
    } else {
        log.error("Error generando recomendaciones con Gemini.");
        throw new RuntimeException("Error al obtener recomendaciones del viaje");
    }
}

private List<String> jsonArrayToList(JSONArray array) {
    List<String> list = new ArrayList<>();
    for (int i = 0; i < array.length(); i++) {
        list.add(array.getString(i));
    }
    return list;
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
      Necesito una lista de recomendaciones para un viaje a {destination}, desde {startDate} hasta {endDate}. Las recomendaciones deben organizarse en las siguientes secciones, cada una como una lista de frases independientes en formato JSON. No incluyas explicaciones adicionales, solo el JSON con estas claves:;
{
  "Vestimenta": [ ... ],
  "Esenciales": [ ... ],
  "Transporte": [ ... ],
  "Actividades": [ ... ],
  "Gastronomia": [ ... ],
  "Temperatura": "Texto breve indicando el rango de temperatura estimado entre {startDate} hasta {endDate}"
}

Cada sección debe incluir recomendaciones específicas, por ejemplo:

- **Vestimenta**: qué tipo de ropa usar según el clima (frío, calor, lluvia).
- **Esenciales**: paraguas, adaptadores de enchufe, protector solar, etc.
- **Transporte**: si se usa transporte público o apps como Uber, subte, etc.
- **Actividades**: excursiones o eventos destacados en esas fechas.
- **Temperatura**: platos típicos, lugares populares y opciones sin TACC, veganas o vegetarianas.

Solo respondé el objeto JSON como está estructurado arriba.

        Escribí en tono amigable y directo, como si le hablaras a un viajero.
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
