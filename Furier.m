classdef Furier < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        DetalledeFourierSlider          matlab.ui.control.Slider
        DetalledeFourierSliderLabel     matlab.ui.control.Label
        SupEditField                    matlab.ui.control.EditField
        SupEditFieldLabel               matlab.ui.control.Label
        InfEditField                    matlab.ui.control.EditField
        InfEditFieldLabel               matlab.ui.control.Label
        TramoEditField                  matlab.ui.control.EditField
        TramoLabel                      matlab.ui.control.Label
        IngreseelperiodoEditField       matlab.ui.control.EditField
        IngreseelperiodoEditFieldLabel  matlab.ui.control.Label
        GraficarButton                  matlab.ui.control.Button
        GuardarTramoButton              matlab.ui.control.Button
        NicolasVargasFloresLabel        matlab.ui.control.Label
        UniversidadDeAntioquiaLabel     matlab.ui.control.Label
        JuanEstebanPinedaLabel          matlab.ui.control.Label
        Prctica2Label                   matlab.ui.control.Label
        UIAxes_2                        matlab.ui.control.UIAxes
        UIAxes                          matlab.ui.control.UIAxes
        tramos = {};
        intervalos = {};
    end

    % Calculos
    methods (Access = private)

        % Funcion para añadir intervalo y tramo dado
        function addTramoIntervalo(app, tramo, inf, sup)
            app.tramos{end + 1} = tramo;
            app.intervalos{end + 1} = [inf, sup];
        end

        % serie
        function serie = doSerie(app, peri, in, tr, detalle)
            t = sym('t');
            n = sym('n');

            w0 = 2*pi / peri;
            a0 = 0; bn = 0; an = 0;

            for i = 1:length(tr)
                a0 = a0 + 2 / peri * int( tr{1, i}, t, in{1, i} );
                an = an + 2 / peri * int( tr{1, i} * cos(n * w0 * t), t, in{1, i} );
                bn = bn + 2 / peri * int( tr{1, i} * sin(n * w0 * t), t, in{1, i} );
            end
            s=0; t1 = -2*peri:4*peri/100:2*peri;
            for k = 1:detalle %20
                s = s + eval(subs(an, n, k) * cos(k* w0 * t1) + eval(subs(bn, n, k)) * sin(k* w0*t1 ));
            end
            s1 = a0 / 2+s;
            serie = plot(app.UIAxes, t1, s1);
            % t1,s1
        end

        % Espectro
        function espectro = doEspectro(app, peri, in, tr)
            t = sym('t');
            n = sym('n');
            w0 = 2*pi / peri;
            a0 = 0; bn = 0; an = 0;
            for i = 1:length(tr)
                a0 = a0 + 2 / peri * int( tr{1, i}, t, in{1, i} );
                an = an + 2 / peri * int( tr{1, i} * cos(n * w0 * t), t, in{1, i} );
                bn = bn + 2 / peri * int( tr{1, i} * sin(n * w0 * t), t, in{1, i} );
            end
            for j = 0:15
                if j == 0
                    frecuencia(1, j+1) = j * w0;
                    energia(1, j+1) = eval(a0);
                else
                    frecuencia(1, j+1) = j * w0;
                    energia(1, j+1) = sqrt(eval(subs(an, n, j)^2) + eval(subs(bn, n, j)^2));
                end
            end
            %plot(app.UIAxes, frecuencia, energia, '*b')
            %hold on
            espectro = plot(app.UIAxes_2, frecuencia, energia);
            % frecuencia, energia
        end
    end

    % Con los botones
    methods (Access = public)

        % Boton para guardar el tramo y el intervalo
        function GuardarTramoButtonPushed(app, ~)
            tramo = str2sym(app.TramoEditField.Value);
            inf = str2sym(app.InfEditField.Value);
            sup = str2sym(app.SupEditField.Value);

            app.addTramoIntervalo(tramo, inf, sup);

            % Limpiar los campos de texto para ingresar un nuevo tramo
            app.TramoEditField.Value = '';
            app.InfEditField.Value = '';
            app.SupEditField.Value = '';

            drawnow; % Actualizar la interfaz de usuario
        end

        % Boton para graficar
        function GraficarButtonPushed(app, ~)
            peri = eval(app.IngreseelperiodoEditField.Value);
            int = app.intervalos;
            tra = app.tramos;
            det = app.DetalledeFourierSlider.Value;
            app.doSerie(peri, int, tra, det);
            app.doEspectro(peri, int, tra);
        end

    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 747 595];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Serie de Fourier')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.FontName = 'Times New Roman';
            app.UIAxes.Position = [372 4 360 285];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.UIFigure);
            title(app.UIAxes_2, 'Espectro')
            xlabel(app.UIAxes_2, 'X')
            ylabel(app.UIAxes_2, 'Y')
            zlabel(app.UIAxes_2, 'Z')
            app.UIAxes_2.FontName = 'Times New Roman';
            app.UIAxes_2.Position = [20 4 360 285];

            % Create Prctica2Label
            app.Prctica2Label = uilabel(app.UIFigure);
            app.Prctica2Label.HorizontalAlignment = 'center';
            app.Prctica2Label.FontSize = 15;
            app.Prctica2Label.FontWeight = 'bold';
            app.Prctica2Label.Position = [280 550 207 23];
            app.Prctica2Label.Text = 'Práctica #2';

            % Create JuanEstebanPinedaLabel
            app.JuanEstebanPinedaLabel = uilabel(app.UIFigure);
            app.JuanEstebanPinedaLabel.HorizontalAlignment = 'center';
            app.JuanEstebanPinedaLabel.FontName = 'Times New Roman';
            app.JuanEstebanPinedaLabel.FontSize = 13;
            app.JuanEstebanPinedaLabel.Position = [320 522 143 22];
            app.JuanEstebanPinedaLabel.Text = 'Juan Esteban Pineda';

            % Create UniversidadDeAntioquiaLabel
            app.UniversidadDeAntioquiaLabel = uilabel(app.UIFigure);
            app.UniversidadDeAntioquiaLabel.HorizontalAlignment = 'center';
            app.UniversidadDeAntioquiaLabel.FontName = 'Times New Roman';
            app.UniversidadDeAntioquiaLabel.FontSize = 13;
            app.UniversidadDeAntioquiaLabel.Position = [320 510 143 22];
            app.UniversidadDeAntioquiaLabel.Text = 'Universidad de Antioquia';
            app.UniversidadDeAntioquiaLabel.FontColor = [0 0.5 0]; % Color verde oscuro

            % Create NicolasVargasFloresLabel
            app.NicolasVargasFloresLabel = uilabel(app.UIFigure);
            app.NicolasVargasFloresLabel.HorizontalAlignment = 'center';
            app.NicolasVargasFloresLabel.FontName = 'Times New Roman';
            app.NicolasVargasFloresLabel.FontSize = 13;
            app.NicolasVargasFloresLabel.Position = [320 495 143 22];
            app.NicolasVargasFloresLabel.Text = 'Nicolas Vargas Flores';

            % Create GuardarTramoButton
            app.GuardarTramoButton = uibutton(app.UIFigure, 'push');
            app.GuardarTramoButton.FontName = 'Times New Roman';
            app.GuardarTramoButton.FontSize = 13;
            app.GuardarTramoButton.ButtonPushedFcn = createCallbackFcn(app, @GuardarTramoButtonPushed, true);
            app.GuardarTramoButton.Position = [340 450 96 24];
            app.GuardarTramoButton.Text = 'Guardar Tramo';

            % Create GraficarButton
            app.GraficarButton = uibutton(app.UIFigure, 'push');
            app.GraficarButton.FontName = 'Times New Roman';
            app.GraficarButton.FontSize = 13;
            app.GraficarButton.ButtonPushedFcn = createCallbackFcn(app, @GraficarButtonPushed, true);
            app.GraficarButton.Position = [500 330 100 24];
            app.GraficarButton.Text = 'Graficar';

            % Create IngreseelperiodoEditFieldLabel
            app.IngreseelperiodoEditFieldLabel = uilabel(app.UIFigure);
            app.IngreseelperiodoEditFieldLabel.HorizontalAlignment = 'right';
            app.IngreseelperiodoEditFieldLabel.FontName = 'Times New Roman';
            app.IngreseelperiodoEditFieldLabel.FontSize = 13;
            app.IngreseelperiodoEditFieldLabel.FontWeight = 'bold';
            app.IngreseelperiodoEditFieldLabel.Position = [106 400 118 22];
            app.IngreseelperiodoEditFieldLabel.Text = 'Ingrese el periodo';

            % Create IngreseelperiodoEditField
            app.IngreseelperiodoEditField = uieditfield(app.UIFigure, 'text');
            app.IngreseelperiodoEditField.HorizontalAlignment = 'center';
            app.IngreseelperiodoEditField.FontName = 'Times New Roman';
            app.IngreseelperiodoEditField.FontSize = 13;
            app.IngreseelperiodoEditField.FontWeight = 'bold';
            app.IngreseelperiodoEditField.Position = [239 400 39 22];

            % Create TramoLabel
            app.TramoLabel = uilabel(app.UIFigure);
            app.TramoLabel.HorizontalAlignment = 'center';
            app.TramoLabel.FontName = 'Times New Roman';
            app.TramoLabel.FontSize = 13;
            app.TramoLabel.FontWeight = 'bold';
            app.TramoLabel.Position = [400 400 42 22];
            app.TramoLabel.Text = 'Tramo';

            % Create TramoEditField
            app.TramoEditField = uieditfield(app.UIFigure, 'text');
            app.TramoEditField.FontName = 'Times New Roman';
            app.TramoEditField.FontSize = 13;
            app.TramoEditField.Position = [450 400 46 22];

            % Create InfEditFieldLabel
            app.InfEditFieldLabel = uilabel(app.UIFigure);
            app.InfEditFieldLabel.HorizontalAlignment = 'center';
            app.InfEditFieldLabel.FontName = 'Times New Roman';
            app.InfEditFieldLabel.FontSize = 13;
            app.InfEditFieldLabel.FontWeight = 'bold';
            app.InfEditFieldLabel.Position = [500 400 25 22];
            app.InfEditFieldLabel.Text = 'Inf';

            % Create InfEditField
            app.InfEditField = uieditfield(app.UIFigure, 'text');
            app.InfEditField.FontName = 'Times New Roman';
            app.InfEditField.FontSize = 13;
            app.InfEditField.Position = [530 400 46 22];

            % Create SupEditFieldLabel
            app.SupEditFieldLabel = uilabel(app.UIFigure);
            app.SupEditFieldLabel.HorizontalAlignment = 'center';
            app.SupEditFieldLabel.FontName = 'Times New Roman';
            app.SupEditFieldLabel.FontSize = 13;
            app.SupEditFieldLabel.FontWeight = 'bold';
            app.SupEditFieldLabel.Position = [590 400 27 22];
            app.SupEditFieldLabel.Text = 'Sup';

            % Create SupEditField
            app.SupEditField = uieditfield(app.UIFigure, 'text');
            app.SupEditField.FontName = 'Times New Roman';
            app.SupEditField.FontSize = 13;
            app.SupEditField.Position = [625 400 46 22];

            % Create DetalledeFourierSliderLabel
            app.DetalledeFourierSliderLabel = uilabel(app.UIFigure);
            app.DetalledeFourierSliderLabel.HorizontalAlignment = 'right';
            app.DetalledeFourierSliderLabel.FontName = 'Times New Roman';
            app.DetalledeFourierSliderLabel.FontSize = 13;
            app.DetalledeFourierSliderLabel.FontWeight = 'bold';
            app.DetalledeFourierSliderLabel.Position = [330 350 106 22];
            app.DetalledeFourierSliderLabel.Text = 'Detalle de Fourier';

            % Create DetalledeFourierSlider
            app.DetalledeFourierSlider = uislider(app.UIFigure);
            app.DetalledeFourierSlider.FontName = 'Times New Roman';
            app.DetalledeFourierSlider.FontSize = 11;
            app.DetalledeFourierSlider.Position = [300 340 150 3];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Furier

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end