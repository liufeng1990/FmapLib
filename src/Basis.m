classdef Basis < dynamicprops
    % Provides the common set of functions that every class that implements (inherits) the Basis class must
    % provide. Known classes that inherit the Basis class are the Laplacian and the Laplace_Beltrami.
    % Notice: This class is acting more like an Abstract class found in languages such Java.
    % (c) Panos Achlioptas 2015  -  http://www.stanford.edu/~optas/FmapLib
    
    properties (SetAccess = private)               
        spectra;    % A struct carrying the eigenvalues and eigenvectors of the basis.
    end
        
    methods (Abstract)
        % Set of methods that each subclass of Basis must implement.
        [Phi, lambda] = compute_spectra(obj, eigs_num)                     
        % Computes eigenvectors-eigenvalues that are interpreted as the basis elements.        
        
        [Proj] = project_functions(obj, eigs_num, varargin)
        % Projects a set of input functions on the basis.
    end
    
    
    
    methods (Access = public)
        % Class Constructor.               
        function obj = Basis()     
            obj.spectra = struct('evals', [], 'evecs', []);
        end
    
        function [evals, evecs] = get_spectra(obj, eigs_num)    
            % Computes the eigenvectors corresponding to the smallest eigenvalues of the Basis matrix. This is 
            % It stores the results in the spectra property of the object (obj.spectra). It also, 
            % automatically reuses the previously computed ones when this is doable, instead of computing them 
            % from the scratch.
            % 
            % Input:
            %           eigs_num    -   (int) number of eigenvector-eigenvalue pairs to be computed. This must be
            %                           smaller than the number of nodes of the associated Matrix.
            %
            % Output:
            %           evals       -   ()
            %           evecs       -   ()

            % The requested number of eigenvalues is larger than what has been previously calculated.
                                                           
            if length(obj.spectra.evals) < eigs_num                     
                [evecs, evals] = obj.compute_spectra(eigs_num);                
                obj.spectra.evals = evals;
                obj.spectra.evecs = evecs;                
            else                                         % Use previously computed spectra.
                evals = obj.spectra.evals;
                evals = evals(1:eigs_num);                
                evecs = obj.spectra.evecs;
                evecs = evecs(:, 1:eigs_num);
            end
        end
        
        function [E] = evecs(obj, eigs_num)
            % 'Convenience function'.
            %  Returns only the eigenvectors of the Basis. (SEE get_spectra() for more info).
            [~, E] = obj.get_spectra(eigs_num);
        end

        function [E] = evals(obj, eigs_num)
            % 'Convenience function'.
            %  Returns only the eigenvectors of the Basis. (SEE get_spectra() for more info).
            [E, ~] = obj.get_spectra(eigs_num);
        end


        function [R] = synthesize_functions(obj, coeffs)
            eigs_num = size(coeffs, 1);            
            R = obj.evecs(eigs_num) * coeffs;            
        end
        
    end
end