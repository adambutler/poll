angular
  .module("Poll")
  .directive "uniqueSecret", ["$http", ($http) ->
        require: "ngModel"
        link: (scope, ele, attrs, c) ->
          scope.$watch attrs.ngModel, ->
            if attrs.uniqueSecret == ""
              c.$setValidity "unique", true
            else
              $http(
                method: "GET"
                url: "/availability/#{attrs.uniqueSecret}"
              ).success (data, status, headers, cfg) ->
                c.$setValidity "unique", data.available
  ]
