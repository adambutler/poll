angular
  .module("Poll")
  .controller "ResultController", ["$scope", "$interval", ($scope, $interval) ->

      $scope.ctx = $('canvas')[0].getContext("2d")

      $scope.chartData = []
      $scope.chartOptions = {
        responsive: true
        showTooltips: false
        animationSteps: 45
      }

      $scope.render = (data) ->
        $scope.$apply ->
          if $scope.chartData.length != data.length
            colors = color.randomColors(data.length)
            $scope.chartData = $.extend true, data, colors
          else
            $scope.chartData = $.extend true, $scope.chartData, data

          total = 0
          for datum, index in data
            total += datum.value

          if $scope.chart?
            for datum, index in data
              $scope.chart.segments[index].value = datum.value
            $scope.chart.update()
          else if total > 0
            $scope.chart = new Chart($scope.ctx).Doughnut($scope.chartData, $scope.chartOptions)

      $scope.updateChart = ->
        $.ajax
          url: "/#{$scope.question}/results.json"
          success: (data) ->
            $scope.render(data)


      $scope.setQuestion = (question) ->
        $scope.question = question
        $scope.updateChart()

        App.votes = App.cable.subscriptions.create "VotesChannel",
          connected: ->
            setTimeout =>
              @perform 'follow', question_id: $("[data-question-secret]").data("question-secret")
            , 500

          received: (data) ->
            $scope.render(data)


  ]
