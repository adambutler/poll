angular
  .module("Poll")
  .controller "ResultController", ["$scope", "$interval", ($scope, $interval) ->

      $scope.ctx = $('#chart')[0].getContext("2d")

      $scope.chartData = []
      $scope.chartOptions = {
        responsive: true
      }

      $scope.updateChart = ->
        $.ajax
          url: "/#{$scope.question}/results.json"
          success: (data) ->
            $scope.$apply ->
              if $scope.chartData.length != data.length
                colors = color.randomColors(data.length)
                $scope.chartData = $.extend true, data, colors
              else
                $scope.chartData = $.extend true, $scope.chartData, data

              if $scope.chart?
                for datum, index in data
                  $scope.chart.segments[index].value = datum.value
                $scope.chart.update()
              else
                $scope.chart = new Chart($scope.ctx).Doughnut($scope.chartData, $scope.chartOptions)


      $scope.setQuestion = (question) ->
        $scope.question = question
        $scope.updateChart()
        pusher = new Pusher("ca686b2d59bada416303")
        channel = pusher.subscribe(question)
        channel.bind "vote", ->
          $scope.updateChart()

  ]
