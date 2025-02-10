#' Validate Tab35 Conditions
#'
#' This function checks if the species data in a plot meets the conditions specified for Tab34.
#'
#' @param x A dataset containing species data.
#' @param y A dataset containing species information for Tab34.
#' @param plot A string specifying the plot to analyze.
#' @return A list containing the validation results.
#' @export

validate.tab35 <- function (x, y, plot = "") {
  # Function code here
}

validate.tab35 <- function (x, y, plot = "") {
	#	x = imm; y = tab.35;	plot = "imm02"
	xi <- x[ plot ]
	xi <- taxonomy(taxonomy(xi))
	zi <- species(y)

	i <- zi$abbr %in% xi$abbr
	zi <- zi[ i, ]
	
	if (nrow(zi) > 0) {
		# Check the conditions
		condition1 <- any(zi$value == 1) # At least one species with value 1
		condition2 <- sum(zi$value == 2) >= 2 # At least two species  with value 2
		condition3 <- sum(zi$value %in% c(2, 3)) >= 3 # At least three species with values 2 or 3
		
		conditions <- c(condition1 = condition1, condition2 = condition2, condition3 = condition3)
		conditions.fullfilled <- any(conditions)
		
		zi$tab35.condition3 <- zi$tab35.condition2 <- zi$tab35.condition1 <- FALSE
		
		if (conditions.fullfilled) {
			if (condition1) {
				zi$tab35.condition1[ zi$value == 1 ] <- TRUE			
			}
			if (condition2) {
				zi$tab35.condition2[ zi$value == 2] <- TRUE			
			}
			if (condition3) {
				zi$tab35.condition3[ zi$value %in% c(2, 3) ] <- TRUE			
			}
		}	
	} else {
		conditions <- c(condition1 = FALSE, condition2 = FALSE, condition3 = FALSE)
		conditions.fullfilled <- FALSE
		zi <- NULL
	}
	
	r <- list(conditions.fullfilled = conditions.fullfilled,
		conditions = conditions,
		assigments = zi[ , -grep(c("plot|layer|cov"), names(zi)) ] )
	return(r)
}

#' Validate Tab34 Conditions
#'
#' This function checks if the species data in a plot meets the conditions specified for Tab34.
#'
#' @param x A dataset containing species data.
#' @param y A dataset containing species information for Tab34.
#' @param plot A string specifying the plot to analyze.
#' @return A list containing the validation results.
#' @export
validate.tab34 <- function (x, y, plot = "") {
  # Function code here
}

validate.tab34 <- function (x, y, plot = "") {
	#	x = imm; y = tab.34;	plot = "imm01"
	#	discard decostand method
	decostand(x) <- NULL	
	xi <- x[ plot ]
	zi <- species(y)

	#	condition 1, cover >= 25%
	i <- zi$abbr %in% abbr(xi)
	yi <- y[ i,]
	xi.test <- xi[, paste0(abbr(yi), "@hl") ]
	
	#	get scaled percentage cover
	xi.scaled <- xi
	xi.scaled <- data.frame(t(as.numeric(xi.scaled)))
	names(xi.scaled) <- "cov"
	# scale cover to sum up to 100%
	xi.scaled$cov.scaled <- round(xi.scaled$cov / sum(xi.scaled$cov) * 100, 1)
	
	xi.test.cover <-	xi.scaled[ rownames(xi.scaled) %in% paste0(abbr(xi.test), "@hl"), ]
	cov.scaled <- sum(xi.test.cover$cov.scaled)
		
	if (cov.scaled >= 25) {
		condition1 <- TRUE		
	} else {
		condition1 <- FALSE
	}

	if (condition1) {
		#	condition 2.1, 2.2, 2.3, and 2.4
		xi <- taxonomy(taxonomy(xi))
	
		i <- zi$abbr %in% xi$abbr
		zi <- zi[ i, ]
		
		if (nrow(zi) > 0) {
			# Check the conditions
			condition2.1 <- any(zi$value == 1) # At least one species with value 1
			condition2.2 <- sum(zi$value == 2) >= 2 # At least two species with value 2
			condition2.3 <- sum(zi$value %in% c(2, 3)) >= 3 # At least three species with values 2 or 3
			condition2.4 <- sum(zi$value %in% c(2, 3, 4)) >= 4 # At least three species with values 2,3 or 4					
			condition2 <- c(condition2.1 = condition2.1, condition2.2 = condition2.2,
				condition2.3 = condition2.3, condition2.4 = condition2.4)
			conditions2.fullfilled <- any(condition2)
			
			zi$tab34.condition2.4 <- zi$tab34.condition2.3 <- zi$tab34.condition2.2 <- zi$tab35.condition2.1 <- FALSE
			
			if (conditions2.fullfilled) {
				if (condition2.1) {
					zi$tab34.condition2.1[ zi$value == 1 ] <- TRUE			
				}
				if (condition2.2) {
					zi$tab34.condition2.2[ zi$value == 2] <- TRUE			
				}
				if (condition2.3) {
					zi$tab34.condition2.3[ zi$value %in% c(2, 3) ] <- TRUE			
				}
				if (condition2.4) {
					zi$tab34.condition2.4[ zi$value %in% c(2, 3, 4) ] <- TRUE			
				}
			}	
		}
	} else {
			condition2 <-
				c(condition2.1 = FALSE, condition2.2 = FALSE, 
				  condition2.3 = FALSE, condition2.4 = FALSE)
			conditions2.fullfilled <- FALSE
			zi <- NULL
	}

	r <- list(
		conditions.fullfilled = all(c(condition1, any(conditions2.fullfilled))),
		conditions = c(condition1 = condition1, condition2),
		assigments = zi[ , -grep(c("plot|layer|cov"), names(zi)) ])
	return(r)
}

#' Validate Tab36 Conditions
#'
#' This function checks if the species data in a plot meets the conditions specified for Tab36.
#'
#' @param x A dataset containing species data.
#' @param y A dataset containing species information for Tab34.
#' @param plot A string specifying the plot to analyze.
#' @param plot A treshold value (9 or 12).
#' @return A list containing the validation results.
#' @export
validate.tab36 <- function (x, y, plot = "", treshold = 9) {
	#	x = imm; y = tab.36; plot = "imm02"; treshold = 9
	xi <- x[ plot ]
	xi <- taxonomy(taxonomy(xi))
	zi <- species(y)

	i <- zi$abbr %in% xi$abbr
	zi <- zi[ i, ]
	
	if (nrow(zi) >= 9) {
		conditions.fullfilled <- TRUE
		ri <- species(species(x[ plot ]))
		ri <- ri[ xi$abbr %in% zi$abbr, ]
		ri.frequent <- ri[ ri$cov != "r", ] # eingestreut
		ri.frequent <- ri.frequent[ ri.frequent$cov != "+", ] # eingestreut		
		if (nrow(ri.frequent >= 1)) {
			conditions.fullfilled <- TRUE
			conditions <- paste0(nrow(ri), " species (", paste0(ri$abbr, collapse = " "), ")")
		} else {
			conditions.fullfilled <- FALSE
			conditions <- paste0(0, " species")
		}
	} else {
		conditions.fullfilled <- FALSE
		conditions <- paste0(0, " species")		
	}
	
	r <- list(
		conditions.fullfilled = conditions.fullfilled,
		conditions = conditions,
		assigments = zi[ , -grep(c("plot|layer|cov"), names(zi)) ])
	return(r)
}