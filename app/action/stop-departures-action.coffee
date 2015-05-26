xhrPromise      = require '../util/xhr-promise'
executeMultiple = require 'fluxible-action-utils/async/executeMultiple'
config          = require '../config'
moment          = require 'moment'

stopInformationRequest = (actionContext, id, done) ->
  if !actionContext.getStore('StopInformationStore').getStop(id)
    xhrPromise.getJson(config.URL.OTP + "index/stops/" + id).then (data) ->
      actionContext.dispatch "StopInformationFound", data
      done()
  else
    done()

stopRoutesRequest = (actionContext, id, done) ->
  if !actionContext.getStore('StopInformationStore').getRoutes(id)
    xhrPromise.getJson(config.URL.OTP + "index/stops/" + id + "/routes").then (data) ->
      actionContext.dispatch "StopRoutesFound", {data: data, id: id}
      done()
  else
    done()

stopDeparturesRequest = (actionContext, id, done) ->
  actionContext.dispatch "StopDeparturesFetchStarted", id
  xhrPromise.getJson(config.URL.OTP + "index/stops/" + id + "/stoptimes?detail=true&numberOfDepartures=5").then (data) ->
    actionContext.dispatch "StopDeparturesFound",
      id: id
      departures: data
    done()

currentDayStopDeparturesRequest = (actionContext, id, done) ->
  actionContext.dispatch "StopDeparturesFetchStarted", id
  xhrPromise.getJson(config.URL.OTP + "index/stops/" + id + "/stoptimes/" + moment().format("YYYYMMDD") + "?detail=true").then (data) ->
    actionContext.dispatch "StopDeparturesFound",
      id: id
      departures: data
    done()

fetchStopsDepartures = (actionContext, options, done) ->
  NearestStopsStore = actionContext.getStore('NearestStopsStore')
  actions = {}
  for stop in NearestStopsStore.getStops().slice(options.from, options.to)
    actions["information" + stop] =
      action: stopInformationRequest
      params: stop
    actions["departures" + stop] =
      action: stopDeparturesRequest
      params: stop
  executeMultiple actionContext, actions, () -> 
    actionContext.dispatch "StopsDeparturesFound"
    done()

stopPageDataRequest =  (actionContext, options, done) ->
  executeMultiple actionContext,
    info:
      action: stopInformationRequest
      params: options.params.stopId
    departures:
      action: currentDayStopDeparturesRequest
      params: options.params.stopId
    , -> done()

module.exports = 
  'stopDeparturesRequest': stopDeparturesRequest
  'stopInformationRequest': stopInformationRequest
  'fetchStopsDepartures': fetchStopsDepartures
  'stopRoutesRequest': stopRoutesRequest
  'stopPageDataRequest': stopPageDataRequest