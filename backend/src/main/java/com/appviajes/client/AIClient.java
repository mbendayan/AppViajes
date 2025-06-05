package com.appviajes.client;

import com.appviajes.model.entities.TravelEntity;
import com.appviajes.model.entities.TravelStepEntity;
import java.util.List;

public interface AIClient {

  List<TravelStepEntity> generateTravelSteps(TravelEntity travelEntity);
  String generateRecommendations(TravelEntity travelEntity);
  List<TravelStepEntity> generateNewTravelSteps(TravelEntity travelEntity);

}
